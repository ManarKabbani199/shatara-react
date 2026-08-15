import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/tweet_model.dart';
import '../Tweet/TweetDetailScreen.dart';


class AdminTweetReportsScreen extends StatefulWidget {
  const AdminTweetReportsScreen({super.key});

  @override
  State<AdminTweetReportsScreen> createState() => _AdminTweetReportsScreenState();
}

class _AdminTweetReportsScreenState extends State<AdminTweetReportsScreen> {
  Map<String, String> userNames = {}; // userId => name
  Map<String, String> tweetTexts = {}; // tweetId => text

  @override
  void initState() {
    super.initState();
    _loadUserNames();
  }

  Future<void> _loadUserNames() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final names = <String, String>{};
    for (var doc in snapshot.docs) {
      names[doc.id] = doc['name'] ?? 'مستخدم مجهول';
    }
    setState(() {
      userNames = names;
    });
  }

  Future<TweetModel?> fetchTweet(String tweetId) async {
    final doc = await FirebaseFirestore.instance.collection('tweets').doc(tweetId).get();
    if (!doc.exists) return null;
    return TweetModel.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
  }

  void deleteReport(String reportId) async {
    await FirebaseFirestore.instance.collection('tweetReports').doc(reportId).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم حذف البلاغ')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('بلاغات المشاركات')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tweetReports')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final reports = snapshot.data!.docs;

          if (reports.isEmpty) {
            return Center(child: Text('لا توجد بلاغات.'));
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final data = report.data() as Map<String, dynamic>;
              final reportId = report.id;
              final tweetId = data['tweetId'];
              final reporterId = data['reporterUserId'];
              final reason = data['reason'] ?? 'غير محدد';
              final timestamp = (data['timestamp'] as Timestamp).toDate();

              final reporterName = userNames[reporterId] ?? reporterId;

              return FutureBuilder<TweetModel?>(
                future: fetchTweet(tweetId),
                builder: (context, tweetSnapshot) {
                  final tweet = tweetSnapshot.data;

                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: ListTile(
                      title: Text(tweet?.text ?? '[تم حذف التغريدة]'),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('المُبلّغ: $reporterName'),
                          Text('السبب: $reason'),
                          Text('الوقت: ${timestamp.toLocal()}'),
                        ],
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) async {
                          if (value == 'عرض') {
                            if (tweet != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => TweetDetailScreen(tweet: tweet),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('لم يتم العثور على التغريدة')),
                              );
                            }
                          } else if (value == 'حذف') {
                            deleteReport(reportId);
                          }
                        },
                        itemBuilder: (context) => [
                          PopupMenuItem(value: 'عرض', child: Text('عرض التغريدة')),
                          PopupMenuItem(value: 'حذف', child: Text('حذف البلاغ')),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
