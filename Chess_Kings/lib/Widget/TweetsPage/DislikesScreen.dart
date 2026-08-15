import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DislikesScreen extends StatelessWidget {
  final List dislikes;

  DislikesScreen({required this.dislikes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('لم يعجبهم')),
      body: ListView.builder(
        itemCount: dislikes.length,
        itemBuilder: (context, index) {
          final userId = dislikes[index];
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