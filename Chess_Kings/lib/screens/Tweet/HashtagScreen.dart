import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../Widget/TweetsPage/TweetTile.dart';
import '../../models/tweet_model.dart';



class HashtagScreen extends StatelessWidget {
  final String hashtag;

  const HashtagScreen({required this.hashtag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(hashtag)),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tweets')
            .where('hashtags', arrayContains: hashtag)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty)
            return Center(child: Text('لا توجد تغريدات تحتوي على هذا الهاشتاق.'));

          final tweets = snapshot.data!.docs.map((doc) =>
              TweetModel.fromMap(doc.data() as Map<String, dynamic>, id: doc.id)).toList();

          return ListView.builder(
            itemCount: tweets.length,
            itemBuilder: (context, index) => TweetTile(tweet: tweets[index]),
          );
        },
      ),
    );
  }
}
