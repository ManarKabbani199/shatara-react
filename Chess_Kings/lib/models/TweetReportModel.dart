import 'package:cloud_firestore/cloud_firestore.dart';

class TweetReportModel {
  final String id;
  final String tweetId;
  final String reporterUserId;
  final String reason;
  final DateTime timestamp;

  TweetReportModel({
    required this.id,
    required this.tweetId,
    required this.reporterUserId,
    required this.reason,
    required this.timestamp,
  });

  factory TweetReportModel.fromMap(Map<String, dynamic> map, String id) {
    return TweetReportModel(
      id: id,
      tweetId: map['tweetId'] ?? '',
      reporterUserId: map['reporterUserId'] ?? '',
      reason: map['reason'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'tweetId': tweetId,
      'reporterUserId': reporterUserId,
      'reason': reason,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
