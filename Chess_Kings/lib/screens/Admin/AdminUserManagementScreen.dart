import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/UserModel.dart';
import '../Tweet/profile_screen.dart';


class AdminUserManagementScreen extends StatefulWidget {
  const AdminUserManagementScreen({super.key});

  @override
  State<AdminUserManagementScreen> createState() => _AdminUserManagementScreenState();
}

class _AdminUserManagementScreenState extends State<AdminUserManagementScreen> {
  String searchQuery = '';

  // ✅ تغيير حالة الحظر
  void toggleBanStatus(String userId, bool currentStatus) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'isBanned': !currentStatus,
    });
  }

  // ✅ حذف المستخدم
  void deleteUser(String userId) async {
    await FirebaseFirestore.instance.collection('users').doc(userId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إدارة المستخدمين')),
      body: Column(
        children: [
          // ✅ مربع البحث
          Padding(
            padding: const EdgeInsets.all(10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'ابحث عن مستخدم...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value.trim().toLowerCase();
                });
              },
            ),
          ),

          // ✅ عرض المستخدمين
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(child: Text('لا يوجد مستخدمون.'));
                }

                final users = snapshot.data!.docs
                    .map((doc) => UserModel.fromMap(doc.data() as Map<String, dynamic>))
                    .where((user) =>
                user.name.toLowerCase().contains(searchQuery) ||
                    user.username.toLowerCase().contains(searchQuery))
                    .toList();

                return ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final user = users[index];

                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: user.profileImageUrl.isNotEmpty
                                ? NetworkImage(user.profileImageUrl)
                                : AssetImage('assets/default_profile.png') as ImageProvider,
                          ),
                          title: Row(
                            children: [
                              Expanded(child: Text(user.name)),
                              if (user.isBanned)
                                Container(
                                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: Colors.red[100],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    'محظور',
                                    style: TextStyle(color: Colors.red, fontSize: 12),
                                  ),
                                ),
                            ],
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('@${user.username}'),
                              Text('البريد: ${user.email}'),
                            ],
                          ),
                          isThreeLine: true,
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(user.isBanned ? Icons.lock_open : Icons.lock),
                                color: user.isBanned ? Colors.green : Colors.red,
                                onPressed: () => toggleBanStatus(user.uid, user.isBanned),
                                tooltip: user.isBanned ? 'إلغاء الحظر' : 'حظر',
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                color: Colors.grey[700],
                                onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text('تأكيد حذف المستخدم'),
                                    content: Text('هل أنت متأكد من حذف هذا الحساب؟'),
                                    actions: [
                                      TextButton(
                                        child: Text('إلغاء'),
                                        onPressed: () => Navigator.pop(context),
                                      ),
                                      ElevatedButton(
                                        child: Text('حذف'),
                                        onPressed: () {
                                          deleteUser(user.uid);
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                tooltip: 'حذف الحساب',
                              ),
                            ],
                          ),

                          // ✅ عند الضغط على المستخدم → افتح صفحة البروفايل
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ProfileScreen(userId: user.uid),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
