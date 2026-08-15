import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../models/tweet_model.dart';
import '../Tweet/TweetDetailScreen.dart';


class AdminTweetManagementScreen extends StatefulWidget {
  const AdminTweetManagementScreen({super.key});

  @override
  State<AdminTweetManagementScreen> createState() => _AdminTweetManagementScreenState();
}

class _AdminTweetManagementScreenState extends State<AdminTweetManagementScreen> {
  String searchQuery = '';
  String searchType = 'userId'; // أو hashtag

  Map<String, String> userNames = {}; // userId => name

  @override
  void initState() {
    super.initState();
    _loadUserNames();
  }

  Future<void> _loadUserNames() async {
    final usersSnapshot = await FirebaseFirestore.instance.collection('users').get();
    final Map<String, String> names = {};
    for (var doc in usersSnapshot.docs) {
      final data = doc.data();
      names[doc.id] = data['name'] ?? 'بدون اسم';
    }
    setState(() {
      userNames = names;
    });
  }

  void deleteTweet(String tweetId) async {
    await FirebaseFirestore.instance.collection('tweets').doc(tweetId).delete();
  }

  bool tweetMatchesSearch(TweetModel tweet) {
    if (searchQuery.isEmpty) return true;

    if (searchType == 'userId') {
      final userName = userNames[tweet.userId]?.toLowerCase() ?? '';
      return userName.contains(searchQuery);
    } else if (searchType == 'hashtag') {
      return tweet.hashtags.any((tag) => tag.toLowerCase().contains(searchQuery));
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إدارة المشاركات')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: searchType == 'userId'
                          ? 'ابحث باسم المستخدم...'
                          : 'ابحث بهاشتاق...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value.trim().toLowerCase();
                      });
                    },
                  ),
                ),
                SizedBox(width: 10),
                DropdownButton<String>(
                  value: searchType,
                  items: [
                    DropdownMenuItem(value: 'userId', child: Text('المستخدم')),
                    DropdownMenuItem(value: 'hashtag', child: Text('هاشتاق')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      searchType = value!;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tweets')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('لا توجد تغريدات.'));
                }

                final tweets = snapshot.data!.docs
                    .map((doc) => TweetModel.fromMap(doc.data() as Map<String, dynamic>, id: doc.id))
                    .where((tweet) => tweetMatchesSearch(tweet))
                    .toList();

                return ListView.builder(
                  itemCount: tweets.length,
                  itemBuilder: (context, index) {
                    final tweet = tweets[index];
                    final userName = userNames[tweet.userId] ?? tweet.userId;

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // ✅ اسم المستخدم + الوقت
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('المستخدم: $userName', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(
                                  tweet.timestamp.toLocal().toString().split('.')[0],
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(height: 8),

                            // ✅ النص
                            Text(tweet.text),
                            SizedBox(height: 8),

                            // ✅ الميديا
                            if (tweet.mediaUrls.isNotEmpty)
                              SizedBox(
                                height: 150,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: tweet.mediaUrls.length,
                                  itemBuilder: (context, i) {
                                    final url = tweet.mediaUrls[i];
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 8.0),
                                      child: url.endsWith('.mp4')
                                          ? Container(
                                        width: 200,
                                        color: Colors.black12,
                                        child: Center(child: Icon(Icons.videocam, size: 40)),
                                      )
                                          : ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(url, width: 150, fit: BoxFit.cover),
                                      ),
                                    );
                                  },
                                ),
                              ),

                            // ✅ الهاشتاقات
                            if (tweet.hashtags.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Wrap(
                                  spacing: 6,
                                  children: tweet.hashtags.map((tag) => Chip(label: Text(tag))).toList(),
                                ),
                              ),

                            // ✅ اللايك والديسلايك
                            Padding(
                              padding: const EdgeInsets.only(top: 6.0),
                              child: Row(
                                children: [
                                  Icon(Icons.thumb_up, size: 16, color: Colors.green),
                                  SizedBox(width: 4),
                                  Text('${tweet.likes.length}'),
                                  SizedBox(width: 12),
                                  Icon(Icons.thumb_down, size: 16, color: Colors.red),
                                  SizedBox(width: 4),
                                  Text('${tweet.dislikes.length}'),
                                ],
                              ),
                            ),

                            // ✅ الأزرار
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => TweetDetailScreen(tweet: tweet),
                                      ),
                                    );
                                  },
                                  child: Text('عرض التفاصيل'),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete),
                                  color: Colors.red,
                                  tooltip: 'حذف التغريدة',
                                  onPressed: () => showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      title: Text('تأكيد الحذف'),
                                      content: Text('هل تريد حذف هذه التغريدة؟'),
                                      actions: [
                                        TextButton(
                                          onPressed: () => Navigator.pop(context),
                                          child: Text('إلغاء'),
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            deleteTweet(tweet.id);
                                            Navigator.pop(context);
                                          },
                                          child: Text('حذف'),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
