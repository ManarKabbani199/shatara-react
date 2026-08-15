import 'package:Chess_Cleverness/screens/Tweet/profile_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/UserModel.dart';
import '../../models/tweet_model.dart';
import '../../shared_data.dart' as shared;
import 'ChatScreen.dart';
import 'TweetDetailScreen.dart';

class NotificationsScreen extends StatefulWidget {
  final String currentUserId;

  const NotificationsScreen({required this.currentUserId});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  @override
  void dispose() {
    _deleteNotifications();
    super.dispose();
  }

  Future<void> _deleteNotifications() async {
    final query = await FirebaseFirestore.instance
        .collection('notifications')
        .where('to', isEqualTo: shared.id_user)
        .get();

    for (var doc in query.docs) {
      await doc.reference.delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('الإشعارات'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('to', isEqualTo: shared.id_user)
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('لا توجد إشعارات.'));
          }

          final notifications = snapshot.data!.docs;

          return ListView.builder(
            itemCount: notifications.length,
            itemBuilder: (context, index) {
              final notification = notifications[index];
              final data = notification.data() as Map<String, dynamic>;
              final fromUserId = data['from'];
              final type = data['type'];
              final tweetId = data['tweetId'];
              final conversationId = data['conversationId'];

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(fromUserId).get(),
                builder: (context, userSnap) {
                  if (!userSnap.hasData || !userSnap.data!.exists) return SizedBox.shrink();
                  final userData = userSnap.data!.data() as Map<String, dynamic>;
                  final fromUser = UserModel.fromMap(userData);

                  String message = '';
                  if (type == 'follow') {
                    message = '${fromUser.name} قام بمتابعتك';
                  } else if (type == 'like') {
                    message = '${fromUser.name} أعجب بتغريدتك';
                  } else if (type == 'retweet') {
                    message = '${fromUser.name} قام بعمل ريتويت لتغريدتك';
                  } else if (type == 'reply') {
                    message = '${fromUser.name} رد على تغريدتك';
                  } else if (type == 'message') {
                    message = '${fromUser.name} أرسل لك رسالة جديدة';
                  } else {
                    return SizedBox();
                  }

                  return ListTile(
                    leading: Icon(
                      type == 'message'
                          ? Icons.message
                          : type == 'like'
                          ? Icons.favorite
                          : Icons.notifications,
                      color: type == 'message' ? Colors.blue : Colors.deepPurple,
                    ),
                    title: Text(message),
                    subtitle: Text('@${fromUser.username}'),
                    onTap: () async {
                      if (type == 'follow') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(userId: fromUser.uid),
                          ),
                        );
                      } else if (type == 'message') {
                        final userSnap = await FirebaseFirestore.instance.collection('users').doc(shared.id_user).get();
                        final currentUser = UserModel.fromMap(userSnap.data() as Map<String, dynamic>);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChatScreen(
                              conversationId: conversationId,
                              currentUser: currentUser,
                              peerUser: fromUser,
                            ),
                          ),
                        );
                      } else if (tweetId != null && tweetId.isNotEmpty) {
                        final tweetDoc = await FirebaseFirestore.instance.collection('tweets').doc(tweetId).get();
                        if (tweetDoc.exists) {
                          final tweetData = tweetDoc.data() as Map<String, dynamic>;
                          final tweet = TweetModel.fromMap(tweetData, id: tweetDoc.id);

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => TweetDetailScreen(tweet: tweet),
                            ),
                          );
                        }
                      }
                    },
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
