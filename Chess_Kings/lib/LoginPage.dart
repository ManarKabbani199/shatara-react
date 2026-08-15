import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    String username = _usernameController.text;
    String password = _passwordController.text;

    // يمكنك إضافة التحقق من صحة البيانات هنا
    // على سبيل المثال، التحقق من اسم المستخدم وكلمة المرور

    // لطباعة القيم على وحدة التحكم
    print('Username: $username');
    print('Password: $password');

    // هنا يمكنك تنفيذ منطق تسجيل الدخول (مثل التحقق من الخدمة)
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('تسجيل الدخول', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF534635),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch, // محاذاة أفضل للعناصر
            children: [

              SizedBox(height: 40),

              Center(
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Alexandria',
                    color: Color(0xFF534635),
                  ),
                ),
              ),

              SizedBox(height: 32),

              // حقل اسم المستخدم
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'اسم المستخدم',
                  labelStyle: TextStyle(fontFamily: 'Alexandria'),
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 16),

              // حقل كلمة المرور
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'كلمة المرور',
                  labelStyle: TextStyle(fontFamily: 'Alexandria'),
                  border: OutlineInputBorder(),
                ),
              ),

              SizedBox(height: 10),

              // ======== نسيت كلمة السر ==========
              GestureDetector(
                onTap: () async {
                  if (_usernameController.text.trim().isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("يرجى إدخال البريد الإلكتروني أولاً")),
                    );
                    return;
                  }

                  try {
                    await FirebaseAuth.instance.sendPasswordResetEmail(
                      email: _usernameController.text.trim(),
                    );

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("تم إرسال رابط استعادة كلمة المرور إلى بريدك")),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("تعذّر إرسال الرابط، تأكد من صحة البريد")),
                    );
                  }
                },
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'نسيت كلمة السر؟',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      color: Color(0xFFAB86B9), // اللون الصح المطلوب
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              // =====================================

              SizedBox(height: 20),

              // زر تسجيل الدخول
              ElevatedButton(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF534635),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    color: Colors.amberAccent,
                    fontFamily: 'Alexandria',
                    fontSize: 16,
                  ),
                ),
              ),

              SizedBox(height: 30),
            ],
          ),
        ),
      ),

      bottomNavigationBar: Footer(),
    );
  }
}

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      color: const Color(0xFF534635),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              FaIcon(FontAwesomeIcons.facebook, color: Colors.white),
              SizedBox(width: 10),
              FaIcon(FontAwesomeIcons.twitter, color: Colors.white),
              SizedBox(width: 10),
              FaIcon(FontAwesomeIcons.instagram, color: Colors.white),
            ],
          ),
          const SizedBox(height: 5),
          const Text(
            'حقوق النشر © 2025 - شطارة',
            style: TextStyle(color: Colors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
