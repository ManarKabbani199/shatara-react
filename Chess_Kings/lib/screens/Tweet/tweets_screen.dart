import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../Widget/TweetsPage/TweetTile.dart';
import '../../models/tweet_model.dart';
import '../../shared_data.dart' as shared;
import 'create_tweet_screen.dart';

class TweetsScreen extends StatefulWidget {
  @override
  State<TweetsScreen> createState() => _TweetsScreenState();
}

class _TweetsScreenState extends State<TweetsScreen> {
  String searchQuery = '';  TextEditingController _searchController = TextEditingController();
  Map<String, int> trends = {};


  @override
  void initState() {
    super.initState();
    _fetchTrends();
  }

  Future<void> _fetchTrends() async {
    final snapshot = await FirebaseFirestore.instance
        .collection('tweets')
        .where('type', isEqualTo: 'tweet')
        .get();

    final Map<String, int> trendMap = {};

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final text = data['text'] ?? '';
      final words = text.toString().split(RegExp(r'\s+'));

      for (var word in words) {
        if (word.startsWith('#') && word.length > 1) {
          trendMap[word] = (trendMap[word] ?? 0) + 1;
        }
      }
    }

    setState(() {
      trends = trendMap;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sortedTrends = trends.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Scaffold(
      appBar: AppBar(
        title: Text('عرض المشاركات'),
        backgroundColor: Colors.deepPurple,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'ابحث عن مشاركه أو هاشتاق...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: searchQuery.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      searchQuery = '';
                    });
                  },
                )
                    : null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.symmetric(horizontal: 12),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tweets')
            .where('type', isEqualTo: 'tweet')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('لا توجد مشاركات بعد.'));
          }

          final allTweets = snapshot.data!.docs.map((doc) {
            return TweetModel.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
          }).toList();

          final filteredTweets = allTweets.where((tweet) {
            final text = tweet.text.toLowerCase();
            return text.contains(searchQuery);
          }).toList();

          return searchQuery.isEmpty
              ? ListView(
            padding: EdgeInsets.all(16),
            children: [
              Text('المواضيع الشائعة', style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              if (sortedTrends.isEmpty)
                ...allTweets.map((tweet) => TweetTile(tweet: tweet)).toList(),
              ...sortedTrends.take(10).map((entry) => ListTile(
                leading: Icon(Icons.trending_up, color: Colors.deepPurple),
                title: Text(entry.key),
                trailing: Text('${entry.value}'),
                onTap: () {
                  _searchController.text = entry.key;
                  setState(() {
                    searchQuery = entry.key.toLowerCase();
                  });
                },
              )),
            ],
          )
              : ListView.builder(
            itemCount: filteredTweets.length,
            itemBuilder: (context, index) {
              return TweetTile(tweet: filteredTweets[index]);
            },
          );
        },
      ),

      floatingActionButton: (shared.id_user != null && shared.id_user.isNotEmpty)
          ? FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CreateTweetScreen()),
          );
        },
        backgroundColor: Colors.deepPurple,
        child: Icon(Icons.add),
      )
          : null,
    );
  }
}
