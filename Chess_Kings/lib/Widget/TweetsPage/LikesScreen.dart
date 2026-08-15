import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class LikesScreen extends StatelessWidget {
  final List likes;

  LikesScreen({required this.likes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('الإعجابات')),
      body: ListView.builder(
        itemCount: likes.length,
        itemBuilder: (context, index) {
          final userId = likes[index];
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return ListTile(title: Text('...'));
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              return ListTile(
                title: Text(userData['username'] ?? 'مستخدم'),
              );
            },
          );
        },
      ),
    );
  }
}
