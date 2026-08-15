import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/tweet_model.dart';
import 'TweetTile.dart';


class RepliesScreen extends StatelessWidget {
  final String tweetId;

  RepliesScreen({required this.tweetId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الردود')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tweets')
            .where('replyTo', isEqualTo: tweetId)
            .orderBy('timestamp')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
          final replies = snapshot.data!.docs.map((doc) {
            return TweetModel.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
          }).toList();

          if (replies.isEmpty) return Center(child: Text('لا توجد ردود'));

          return ListView.builder(
            itemCount: replies.length,
            itemBuilder: (context, index) => TweetTile(tweet: replies[index]),
          );
        },
      ),
    );
  }
}