// chat_service.dart

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> createOrGetChat(String uid1, String uid2) async {
    final existingChat = await _firestore
        .collection('chats')
        .where('members', arrayContains: uid1)
        .get();

    for (var doc in existingChat.docs) {
      final members = List<String>.from(doc['members']);
      if (members.contains(uid2)) {
        return doc.id;
      }
    }

    final newChat = await _firestore.collection('chats').add({
      'members': [uid1, uid2],
      'lastMessage': '',
      'lastSenderId': '',
      'timestamp': FieldValue.serverTimestamp(),
    });

    return newChat.id;
  }

  Stream<QuerySnapshot> getUserChats(String uid) {
    return _firestore
        .collection('chats')
        .where('members', arrayContains: uid)
        .snapshots();
  }

  Stream<QuerySnapshot> getChatMessages(String chatId) {
    return _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
  }

  Future<void> sendMessage(String chatId, String senderId, String text) async {
    final message = {
      'text': text,
      'senderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    };

    await _firestore
        .collection('chats')
        .doc(chatId)
        .collection('messages')
        .add(message);

    await _firestore.collection('chats').doc(chatId).update({
      'lastMessage': text,
      'lastSenderId': senderId,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
