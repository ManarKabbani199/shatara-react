import 'package:flutter/material.dart';
import '../../MainHome.dart';
import 'AdminManagementScreen.dart';
import 'AdminUserManagementScreen.dart';
import 'AdminTweetManagementScreen.dart';
import 'AdminUserReportsScreen.dart';
import 'AdminTweetReportsScreen.dart';
import 'AdminStatsScreen.dart';

class AdminDashboardScreen extends StatelessWidget {
  final String adminName;

  const AdminDashboardScreen({super.key, required this.adminName});

  void _navigateTo(BuildContext context, Widget screen) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => screen));
  }

  Widget _buildSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required List<Map<String, dynamic>> actions,
  }) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Icon(icon, color: Colors.deepPurple),
                SizedBox(width: 8),
                Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
              ],
            ),
            ...actions.map((action) => ListTile(
              title: Text(action['label']),
              trailing: Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () => _navigateTo(context, action['screen']),
            )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('لوحة تحكم المشرف'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            tooltip: 'تسجيل الخروج',
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainHome()));
            },
          )
        ],
      ),
      body: ListView(
        children: [
          SizedBox(height: 16),
          Center(
            child: Text('أهلاً بك، $adminName 👋',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          SizedBox(height: 16),

          // إدارة المشرفين
          _buildSection(
            context: context,
            icon: Icons.admin_panel_settings,
            title: 'إدارة المشرفين',
            actions: [
              {
                'label': 'إدارة المشرفين',
                'screen': AdminManagementScreen(),
              },
            ],
          ),

          // إدارة المستخدمين
          _buildSection(
            context: context,
            icon: Icons.group,
            title: 'إدارة المستخدمين',
            actions: [
              {
                'label': 'إدارة المستخدمين',
                'screen': AdminUserManagementScreen(),
              },
            ],
          ),

          // إدارة المشاركات
          _buildSection(
            context: context,
            icon: Icons.edit_note,
            title: 'إدارة المشاركات',
            actions: [
              {
                'label': 'إدارة المشاركات',
                'screen': AdminTweetManagementScreen(),
              },
            ],
          ),

          // إدارة البلاغات
          _buildSection(
            context: context,
            icon: Icons.report,
            title: 'إدارة البلاغات',
            actions: [
              {
                'label': 'إبلاغات عن المستخدمين',
                'screen': AdminUserReportsScreen(),
              },
              {
                'label': 'إبلاغات عن المشاركات',
                'screen': AdminTweetReportsScreen(),
              },
            ],
          ),

          // الإحصائيات
          _buildSection(
            context: context,
            icon: Icons.bar_chart,
            title: 'الإحصائيات',
            actions: [
              {
                'label': 'إحصائيات المستخدمين و المشاركات',
                'screen': AdminStatsScreen(),
              },
            ],
          ),
        ],
      ),
    );
  }
}
