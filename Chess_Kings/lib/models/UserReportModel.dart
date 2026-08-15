import 'package:cloud_firestore/cloud_firestore.dart';

class UserReportModel {
  final String id;
  final String reportedUserId;
  final String reporterUserId;
  final String reason;
  final DateTime timestamp;

  UserReportModel({
    required this.id,
    required this.reportedUserId,
    required this.reporterUserId,
    required this.reason,
    required this.timestamp,
  });

  factory UserReportModel.fromMap(Map<String, dynamic> map, String id) {
    return UserReportModel(
      id: id,
      reportedUserId: map['reportedUserId'] ?? '',
      reporterUserId: map['reporterUserId'] ?? '',
      reason: map['reason'] ?? '',
      timestamp: (map['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'reportedUserId': reportedUserId,
      'reporterUserId': reporterUserId,
      'reason': reason,
      'timestamp': Timestamp.fromDate(timestamp),
    };
  }
}
