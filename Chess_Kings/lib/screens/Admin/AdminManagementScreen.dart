import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminManagementScreen extends StatefulWidget {
  const AdminManagementScreen({super.key});

  @override
  State<AdminManagementScreen> createState() => _AdminManagementScreenState();
}

class _AdminManagementScreenState extends State<AdminManagementScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String? editingAdminId;

  void saveAdmin() async {
    if (!_formKey.currentState!.validate()) return;

    final adminData = {
      'email': emailController.text.trim(),
      'name': nameController.text.trim(),
      'password': passwordController.text.trim(),
    };

    if (editingAdminId != null) {
      await FirebaseFirestore.instance.collection('admins').doc(editingAdminId).update(adminData);
    } else {
      await FirebaseFirestore.instance.collection('admins').add(adminData);
    }

    clearForm();
  }

  void editAdmin(String id, Map<String, dynamic> data) {
    setState(() {
      editingAdminId = id;
      emailController.text = data['email'] ?? '';
      nameController.text = data['name'] ?? '';
      passwordController.text = data['password'] ?? '';
    });
  }

  void deleteAdmin(String id) async {
    await FirebaseFirestore.instance.collection('admins').doc(id).delete();
  }

  void clearForm() {
    setState(() {
      editingAdminId = null;
      emailController.clear();
      nameController.clear();
      passwordController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('إدارة المدراء')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'البريد الإلكتروني'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'مطلوب' : null,
                  ),
                  TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(labelText: 'الاسم'),
                    validator: (value) =>
                    value == null || value.isEmpty ? 'مطلوب' : null,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(labelText: 'كلمة المرور'),
                    obscureText: true,
                    validator: (value) =>
                    value == null || value.isEmpty ? 'مطلوب' : null,
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: saveAdmin,
                        child: Text(editingAdminId != null ? 'تعديل المدير' : 'إضافة مدير'),
                      ),
                      SizedBox(width: 10),
                      if (editingAdminId != null)
                        TextButton(
                          onPressed: clearForm,
                          child: Text('إلغاء التعديل'),
                        ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance.collection('admins').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  final admins = snapshot.data!.docs;

                  if (admins.isEmpty) {
                    return Center(child: Text('لا يوجد مدراء.'));
                  }

                  return ListView.builder(
                    itemCount: admins.length,
                    itemBuilder: (context, index) {
                      final doc = admins[index];
                      final data = doc.data() as Map<String, dynamic>;

                      return ListTile(
                        title: Text(data['name'] ?? ''),
                        subtitle: Text(data['email'] ?? ''),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => editAdmin(doc.id, data),
                            ),
                            IconButton(
                              icon: Icon(Icons.delete, color: Colors.red),
                              onPressed: () => showDialog(
                                context: context,
                                builder: (_) => AlertDialog(
                                  title: Text('تأكيد الحذف'),
                                  content: Text('هل تريد حذف هذا المدير؟'),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text('إلغاء'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        deleteAdmin(doc.id);
                                        Navigator.pop(context);
                                      },
                                      child: Text('حذف'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
