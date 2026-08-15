import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/UserModel.dart';
import '../../services/ChatService.dart';
import 'ChatScreen.dart';



class ChatListScreen extends StatefulWidget {
  @override
  _ChatListScreenState createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
  UserModel? currentUser;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUserId).get();
    if (userDoc.exists) {
      setState(() {
        currentUser = UserModel.fromMap(userDoc.data() as Map<String, dynamic>);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentUser == null) {
      return Scaffold(
        appBar: AppBar(title: Text('المحادثات')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('المحادثات'),
        backgroundColor: Colors.deepPurple,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: ChatService().getUserChats(currentUserId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('لا توجد محادثات بعد'));
          }

          final chats = snapshot.data!.docs;

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chatData = chats[index].data() as Map<String, dynamic>;
              final chatId = chats[index].id;
              final members = List<String>.from(chatData['members'] ?? []);
              final otherUserId = members.firstWhere((id) => id != currentUserId, orElse: () => '');
              final lastMessage = chatData['lastMessage'] ?? '';

              if (otherUserId.isEmpty) return SizedBox.shrink();

              return FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(otherUserId).get(),
                builder: (context, userSnap) {
                  if (!userSnap.hasData || !userSnap.data!.exists) return SizedBox.shrink();

                  final userData = userSnap.data!.data() as Map<String, dynamic>;
                  final peerUser = UserModel.fromMap(userData);

                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: peerUser.profileImageUrl.isNotEmpty
                          ? NetworkImage(peerUser.profileImageUrl)
                          : AssetImage('assets/default_profile.png') as ImageProvider,
                    ),
                    title: Text(peerUser.name),
                    subtitle: lastMessage.isNotEmpty
                        ? Text(
                      lastMessage,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )
                        : Text('@${peerUser.username}'),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ChatScreen(
                            conversationId: chatId,
                            currentUser: currentUser!,
                            peerUser: peerUser,
                          ),
                        ),
                      );
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
