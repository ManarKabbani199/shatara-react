import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FeedScreen extends StatefulWidget {
  @override
  _FeedScreenState createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  List<Map<String, dynamic>> _tweets = [
    {
      'id': '1',
      'content': 'هذا هو التغريدة الأولى',
      'playerName': 'الأستاذ أحمد ميموني',
      'likes': 5,
      'retweets': 2,
    },
    {
      'id': '2',
      'content': 'تغريدة أخرى رائعة',
      'playerName': 'المهندسة منار قباني',
      'likes': 3,
      'retweets': 1,
    },
  ];

  void _likeTweet(String tweetId, int currentLikes) {
    setState(() {
      int index = _tweets.indexWhere((tweet) => tweet['id'] == tweetId);
      if (index != -1) {
        _tweets[index]['likes'] = currentLikes + 1;
      }
    });
  }

  void _retweet(String tweetId, int currentRetweets) {
    setState(() {
      int index = _tweets.indexWhere((tweet) => tweet['id'] == tweetId);
      if (index != -1) {
        _tweets[index]['retweets'] = currentRetweets + 1;
      }
    });
  }

  void _replyToTweet(String tweetId, String content) {
    print('رد على التغريدة $tweetId: $content');
  }

  void _reportTweet(String tweetId) {
    print('تغريدة $tweetId تم الإبلاغ عنها');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تواصل عبر الشبكه', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF534635),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: _tweets.length,
        itemBuilder: (context, index) {
          final tweet = _tweets[index];
          return Container(
            margin: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white60, // لون الخلفية للتغريدة
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[400]!, width: 1),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tweet['content'],
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                const SizedBox(height: 5),
                Text(
                  'اللاعب: ${tweet['playerName']}',
                  style: TextStyle(color: Colors.amberAccent, fontSize: 14),
                ),
                const SizedBox(height: 5),
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.thumb_up),
                      onPressed: () => _likeTweet(tweet['id'], tweet['likes'] ?? 0),
                    ),
                    Text('${tweet['likes'] ?? 0}'),
                    IconButton(
                      icon: Icon(Icons.repeat),
                      onPressed: () => _retweet(tweet['id'], tweet['retweets'] ?? 0),
                    ),
                    Text('${tweet['retweets'] ?? 0}'),
                    IconButton(
                      icon: Icon(Icons.comment),
                      onPressed: () => _replyToTweet(tweet['id'], 'Nice post!'),
                    ),
                    IconButton(
                      icon: Icon(Icons.report),
                      onPressed: () => _reportTweet(tweet['id']),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: Footer(),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xFF534635),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
              SizedBox(width: 10),
              FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
              SizedBox(width: 10),
              FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'حقوق النشر © 2025 - شطارة',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}