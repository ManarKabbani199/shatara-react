import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/tweet_model.dart';
import 'TweetTile.dart';



class AllTweetsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('جميع المشاركات'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tweets')
            .where('type', isEqualTo: 'tweet')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('لا توجد مشاركات.'));
          }

          final tweets = snapshot.data!.docs.map((doc) {
            return TweetModel.fromMap(doc.data() as Map<String, dynamic>, id: doc.id);
          }).toList();

          return ListView.builder(
            itemCount: tweets.length,
            itemBuilder: (context, index) {
              return TweetTile(tweet: tweets[index]);
            },
          );
        },
      ),
    );
  }
}
