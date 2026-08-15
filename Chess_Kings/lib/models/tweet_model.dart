import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';  // تأكد من استيراد مكتبة intl لتنسيق التاريخ

class TweetModel {
  final String id;
  final String userId;
  final String text;
  final List<String> mediaUrls;
  final List<String> likes;
  final List<String> dislikes;
  final String? replyTo;
  final String? conversationId;
  final String type;
  final DateTime timestamp;
  final List<String> hashtags;

  TweetModel({
    required this.id,
    required this.userId,
    required this.text,
    required this.mediaUrls,
    required this.likes,
    required this.dislikes,
    required this.replyTo,
    required this.conversationId,
    required this.type,
    required this.timestamp,
    required this.hashtags,
  });

  factory TweetModel.fromMap(Map<String, dynamic> map, {String? id}) {
    DateTime timestamp;

    // تحقق من وجود timestamp في الـ map
    print("timestamp in map: ${map['timestamp']}");

    if (map['timestamp'] is String) {
      // إذا كان timestamp من نوع String
      try {
        timestamp = DateTime.parse(map['timestamp']);
        print("Parsed timestamp from String: $timestamp");
      } catch (e) {
        timestamp = DateTime.now();  // نستخدم التاريخ الحالي في حال فشل التحويل
        print('Error parsing timestamp from String: $e');
      }
    } else if (map['timestamp'] is Timestamp) {
      // إذا كان timestamp من نوع Timestamp
      timestamp = (map['timestamp'] as Timestamp).toDate();
      print("Parsed timestamp from Timestamp: $timestamp");
    } else {
      // إذا كانت القيمة غير صالحة أو غير موجودة
      timestamp = DateTime.now();  // نستخدم التاريخ الحالي كقيمة افتراضية
      print("Using current timestamp: $timestamp");
    }

    return TweetModel(
      id: id ?? '',
      userId: map['userId'] ?? '',
      text: map['text'] ?? '',
      mediaUrls: List<String>.from(map['mediaUrls'] ?? []),
      likes: List<String>.from(map['likes'] ?? []),
      dislikes: List<String>.from(map['dislikes'] ?? []),
      replyTo: map['replyTo'],
      conversationId: map['conversationId'],
      type: map['type'] ?? 'tweet',
      timestamp: timestamp,
      hashtags: List<String>.from(map['hashtags'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'text': text,
      'mediaUrls': mediaUrls,
      'likes': likes,
      'dislikes': dislikes,
      'replyTo': replyTo,
      'conversationId': conversationId,
      'type': type,
      'timestamp': Timestamp.fromDate(timestamp),
      'hashtags': hashtags,
    };
  }
}
