import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationService {
  static Future<int> getUnreadNotificationCount(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('notifications')
        .where('to', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    return snapshot.docs.length;
  }

  static Future<int> getUnreadMessagesCount(String userId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('messages')
        .where('to', isEqualTo: userId)
        .where('isRead', isEqualTo: false)
        .get();

    return snapshot.docs.length;
  }
}
