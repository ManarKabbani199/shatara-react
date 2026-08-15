import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../global/common/toast.dart';
import 'HomePage.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController emailController = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      showToast(message: 'يرجى إدخال البريد الإلكتروني');
      return;
    }

    setState(() => _loading = true);

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      showToast(message: 'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك');
      if (!mounted) return;
      Navigator.pop(context);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        showToast(message: 'هذا البريد غير مسجل');
      } else if (e.code == 'invalid-email') {
        showToast(message: 'صيغة البريد غير صحيحة');
      } else {
        showToast(message: 'حدث خطأ، حاول لاحقاً');
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Stack(
        children: [
          /// 🔹 الخلفية
          Positioned.fill(
            child: Image.asset(
              'assets/looog.png',
              fit: BoxFit.cover,
            ),
          ),

          /// 🔹 المحتوى (أقصى اليمين)
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            bottom: 0,
            child: SingleChildScrollView(
              child: Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(
                    right: 50,
                    left: 20,
                    bottom: 40,
                  ),
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Container(
                      width: 420,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 25,
                        vertical: 35,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset('assets/logon.png', width: 250),
                          const SizedBox(height: 40),

                          Text(
                            'نسيت كلمة المرور',
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: isMobile ? 16 : 26,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6B4E45),
                            ),
                          ),

                          const SizedBox(height: 10),

                          Text(
                            'أدخل بريدك الإلكتروني وسنرسل لك رابط إعادة تعيين كلمة المرور.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: 'Alexandria',
                              fontSize: isMobile ? 12 : 14,
                              color: const Color(0xFF6B4E45),
                            ),
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: 350,
                            child: TextField(
                              controller: emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'البريد الإلكتروني',
                                prefixIcon: Icon(Icons.email),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),

                          const SizedBox(height: 30),

                          SizedBox(
                            width: 300,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _sendResetEmail,
                              style: ElevatedButton.styleFrom(
                                backgroundColor:
                                const Color(0xFFAB86B9),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero,
                                ),
                              ),
                              child: _loading
                                  ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                                  : const Text(
                                'إرسال رابط إعادة التعيين',
                                style: TextStyle(
                                  fontFamily: 'Alexandria',
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 20),

                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: const Text(
                              'العودة إلى تسجيل الدخول',
                              style: TextStyle(
                                fontFamily: 'Alexandria',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF6B4E45),
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),

          /// 🔥 أعلى اليسار: textn + زر Home
          Positioned(
            top: 0,
            left: 0,
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 16, top: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// صورة النص



                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const Home()),
                        );
                      },
                      child: Image.asset(
                        'assets/catBtn.png',
                        width: 100,
                      ),
                    ),

                    const SizedBox(width: 15),

                    Image.asset(
                      'assets/textn.png',
                      width: 125,
                    ),

                    /// زر العودة إلى Home

                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
