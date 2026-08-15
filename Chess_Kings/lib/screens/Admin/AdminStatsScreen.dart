import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminStatsScreen extends StatefulWidget {
  const AdminStatsScreen({super.key});

  @override
  State<AdminStatsScreen> createState() => _AdminStatsScreenState();
}

class _AdminStatsScreenState extends State<AdminStatsScreen> {
  int totalUsers = 0;
  int totalTweets = 0;

  Map<String, int> userTweetCounts = {}; // userId => tweetCount
  Map<String, String> userNames = {}; // userId => name

  List<Map<String, dynamic>> topInteractiveTweets = []; // tweet info

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchStats();
  }

  Future<void> fetchStats() async {
    // 🔹 جلب عدد المستخدمين
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    totalUsers = usersSnapshot.size;

    for (var doc in usersSnapshot.docs) {
      userNames[doc.id] = doc.data()['name'] ?? 'مستخدم';
    }

    // 🔹 جلب جميع التغريدات
    final tweetsSnapshot = await FirebaseFirestore.instance.collection('tweets').get();
    totalTweets = tweetsSnapshot.size;

    // 🔹 تحليل التغريدات
    final List<Map<String, dynamic>> tweetsList = [];

    for (var doc in tweetsSnapshot.docs) {
      final data = doc.data();
      final uid = data['userId'];
      if (uid != null) {
        userTweetCounts[uid] = (userTweetCounts[uid] ?? 0) + 1;
      }

      tweetsList.add({
        'id': doc.id,
        'text': data['text'] ?? '',
        'likes': (data['likes'] as List?)?.length ?? 0,
        'retweets': data['retweetedFrom'] != null ? 1 : 0,
      });
    }

    // 🔹 التغريدات الأكثر تفاعلًا
    tweetsList.sort((a, b) {
      final aScore = a['likes'] + a['retweets'];
      final bScore = b['likes'] + b['retweets'];
      return bScore.compareTo(aScore);
    });
    topInteractiveTweets = tweetsList.take(5).toList();

    setState(() {
      isLoading = false;
    });
  }

  // 🔹 مخطط المستخدمين الأكثر تغريدًا
  List<BarChartGroupData> getBarChartData() {
    final topUsers = userTweetCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5 = topUsers.take(5).toList();

    return List.generate(top5.length, (index) {
      final entry = top5[index];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: entry.value.toDouble(),
            color: Colors.deepPurple,
            width: 20,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    });
  }

  List<String> getBarChartLabels() {
    final topUsers = userTweetCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5 = topUsers.take(5).toList();
    return top5.map((entry) => userNames[entry.key] ?? 'مستخدم').toList();
  }

  // 🔹 مخطط التغريدات الأكثر تفاعلًا
  List<BarChartGroupData> getTopTweetsBarChart() {
    return List.generate(topInteractiveTweets.length, (index) {
      final item = topInteractiveTweets[index];
      final total = item['likes'] + item['retweets'];
      return BarChartGroupData(
        x: index,
        barRods: [
          BarChartRodData(
            toY: total.toDouble(),
            color: Colors.orange,
            width: 20,
          ),
        ],
        showingTooltipIndicators: [0],
      );
    });
  }

  List<String> getTopTweetLabels() {
    return topInteractiveTweets.map((e) {
      String text = e['text'];
      return text.length > 10 ? '${text.substring(0, 10)}...' : text;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final labels = getBarChartLabels();
    final tweetLabels = getTopTweetLabels();

    return Scaffold(
      appBar: AppBar(title: Text('إحصائيات عامة')),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Card(
              child: ListTile(
                leading: Icon(Icons.person, color: Colors.deepPurple),
                title: Text('إجمالي المستخدمين'),
                trailing: Text('$totalUsers'),
              ),
            ),
            Card(
              child: ListTile(
                leading: Icon(Icons.message, color: Colors.deepPurple),
                title: Text('إجمالي المشاركات'),
                trailing: Text('$totalTweets'),
              ),
            ),
            SizedBox(height: 35),
            Text(
              'أكثر المستخدمين نشاطًا',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < labels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                labels[index],
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: getBarChartData(),
                ),
              ),
            ),
            SizedBox(height: 75),
            Text(
              'أكثر المشاركات تفاعلًا',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 250,
              child: BarChart(
                BarChartData(
                  alignment: BarChartAlignment.spaceAround,
                  titlesData: FlTitlesData(
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index < tweetLabels.length) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                tweetLabels[index],
                                style: TextStyle(fontSize: 10),
                              ),
                            );
                          }
                          return SizedBox.shrink();
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                    ),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: false),
                  barGroups: getTopTweetsBarChart(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
