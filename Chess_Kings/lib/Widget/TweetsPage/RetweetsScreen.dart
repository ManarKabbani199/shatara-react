import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RetweetsScreen extends StatelessWidget {
  final String tweetId;

  RetweetsScreen({required this.tweetId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("إعادات التغريد")),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('tweets')
            .where('retweetedFrom', isEqualTo: tweetId)
            .where('type', isEqualTo: 'retweet')
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData)
            return Center(child: CircularProgressIndicator());

          final retweets = snapshot.data!.docs;

          if (retweets.isEmpty) return Center(child: Text("لا توجد إعادات تغريد"));

          return ListView.builder(
            itemCount: retweets.length,
            itemBuilder: (context, index) {
              final retweet = retweets[index].data() as Map<String, dynamic>;
              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(retweet['userId'])
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) return SizedBox();
                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                  return ListTile(
                    title: Text(userData['username'] ?? 'مستخدم'),
                    subtitle: Text("أعاد التغريد"),
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