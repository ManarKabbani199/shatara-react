import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../Tweet/profile_screen.dart';


class AdminUserReportsScreen extends StatefulWidget {
  const AdminUserReportsScreen({super.key});

  @override
  State<AdminUserReportsScreen> createState() => _AdminUserReportsScreenState();
}

class _AdminUserReportsScreenState extends State<AdminUserReportsScreen> {
  Map<String, String> userNames = {}; // userId -> name

  @override
  void initState() {
    super.initState();
    _loadUserNames();
  }

  Future<void> _loadUserNames() async {
    final snapshot = await FirebaseFirestore.instance.collection('users').get();
    final Map<String, String> namesMap = {};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      namesMap[doc.id] = data['name'] ?? 'بدون اسم';
    }
    setState(() {
      userNames = namesMap;
    });
  }

  void banUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isBanned': true,
    });
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('تم حظر المستخدم')));
  }

  void deleteReport(String reportId) async {
    await FirebaseFirestore.instance.collection('userReports').doc(reportId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('بلاغات المستخدمين')),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('userReports')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Center(child: CircularProgressIndicator());

          final reports = snapshot.data!.docs;

          if (reports.isEmpty) {
            return Center(child: Text('لا توجد بلاغات.'));
          }

          return ListView.builder(
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              final data = report.data() as Map<String, dynamic>;
              final reportId = report.id;
              final reportedUserId = data['reportedUserId'];
              final reporterUserId = data['reporterUserId'];
              final reason = data['reason'] ?? 'بدون سبب';
              final timestamp = (data['timestamp'] as Timestamp).toDate();

              final reportedName = userNames[reportedUserId] ?? reportedUserId;
              final reporterName = userNames[reporterUserId] ?? reporterUserId;

              return Card(
                margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: ListTile(
                  title: Text('بلاغ على: $reportedName'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('المُبلِّغ: $reporterName'),
                      Text('السبب: $reason'),
                      Text('الوقت: ${timestamp.toLocal()}'),
                    ],
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'عرض') {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ProfileScreen(userId: reportedUserId),
                          ),
                        );
                      } else if (value == 'حظر') {
                        banUser(reportedUserId);
                      } else if (value == 'حذف') {
                        deleteReport(reportId);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(value: 'عرض', child: Text('عرض المستخدم')),
                      PopupMenuItem(value: 'حظر', child: Text('حظر المستخدم')),
                      PopupMenuItem(value: 'حذف', child: Text('حذف البلاغ')),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
