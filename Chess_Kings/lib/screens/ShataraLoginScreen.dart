import 'package:flutter/material.dart';
import '../models/UserModel.dart';
import '../services/presence_service.dart';
import '../shared_data.dart' as shared;
import 'HomePage.dart';
import 'NewHome.dart';
import 'ShataraRegisterPage.dart';
import '../../../../global/common/toast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import '../utils/storage.dart';
import 'ForgotPasswordPage.dart';

class ShataraLoginScreen extends StatefulWidget {
  const ShataraLoginScreen({Key? key}) : super(key: key);

  @override
  State<ShataraLoginScreen> createState() => _ShataraLoginScreenState();
}

class _ShataraLoginScreenState extends State<ShataraLoginScreen> {
  final TextEditingController emailController_l = TextEditingController();
  final TextEditingController passwordController_l = TextEditingController();
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() => _obscureText = !_obscureText);
  }

  @override
  void dispose() {
    emailController_l.dispose();
    passwordController_l.dispose();
    super.dispose();
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

          /// 🔹 الفورم (يمين الصفحة)
          Positioned(
            top: 120, // مهم حتى لا يغطي العناصر العلوية
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
                  child: _buildLoginForm(isMobile),
                ),
              ),
            ),
          ),

          /// 🔹 تنبيه الموبايل
          if (isMobile)
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.red,
                padding: const EdgeInsets.all(10),
                child: const Text(
                  'في الوقت الحالي شطارة تعمل بشكل أفضل على الكمبيوتر',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Alexandria',
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

          /// 🔥 أعلى اليسار: textn + زر العودة
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
                          MaterialPageRoute(builder: (_) => const NewHome()),
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

  /// 🔹 الفورم (خلفية بيضاء شفافة)
  Widget _buildLoginForm(bool isMobile) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: 420,
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 35),
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
            Image.asset('assets/logon.png', width: 300),
            const SizedBox(height: 75),

            Text(
              'عضو في شطارة',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 14 : 26,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4E45),
              ),
            ),

            const SizedBox(height: 10),

            Text(
              'أهلا بعودتك! استخدم بياناتك لتسجيل الدخول مباشرة.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 11 : 13,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4E45),
              ),
            ),

            const SizedBox(height: 30),

            _inputField(
              controller: emailController_l,
              label: 'البريد الإلكتروني',
              icon: Icons.email,
            ),

            const SizedBox(height: 20),

            _inputField(
              controller: passwordController_l,
              label: 'كلمة المرور',
              icon: Icons.lock_outline,
              obscure: _obscureText,
              suffix: IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: Colors.grey,
                ),
                onPressed: _togglePasswordVisibility,
              ),
            ),

            const SizedBox(height: 8),

            Align(
              alignment: Alignment.centerRight, // غيّرها centerRight إذا تحب
              child: GestureDetector(
                onTap: () {
                  // TODO: صفحة استعادة كلمة المرور
                  Navigator.push(context, MaterialPageRoute(builder: (_) => ForgotPasswordPage()));
                },
                child: Text(
                  'نسيت كلمة المرور؟',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: isMobile ? 11 : 13,
                    color: const Color(0xFF989898),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),


            const SizedBox(height: 30),

            Center(
              child: SizedBox(
                width: 325,
                child: ElevatedButton(
                  onPressed: _signin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAB86B9),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  child: const Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(child: Divider(color: Colors.grey.shade400)),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    'او عن طريق',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.grey.shade400)),
              ],
            ),

            const SizedBox(height: 20),

            GestureDetector(
              onTap: signInWithGoogle,
              child: Image.asset(
                'assets/google_logo.png',
                width: 40,
              ),
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'ليس لديك حساب؟',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: isMobile ? 10 : 13,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(width: 6),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ShataraRegisterPage(),
                      ),
                    );
                  },
                  child: Text(
                    'أنشئ حساب جديد',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: isMobile ? 10 : 13,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF6B4E45),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            Text(
              'جميع الحقوق محفوظة شطارة © 2025',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 10 : 13,
                color: const Color(0xFF6B4E45),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔹 حقل إدخال
  Widget _inputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool obscure = false,
    Widget? suffix,
  }) {
    return SizedBox(
      width: 400,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextField(
          controller: controller,
          obscureText: obscure,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon),
            suffixIcon: suffix,
            border: const OutlineInputBorder(),
          ),
        ),
      ),
    );
  }

  /// 🔐 تسجيل الدخول
  Future<void> _signin() async {
    try {
      if (kIsWeb) {
        await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      }

      final userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController_l.text.trim(),
        password: passwordController_l.text.trim(),
      );

      final uid = userCredential.user!.uid;
      await saveUid(uid);
      shared.id_user = uid;

      await PresenceService.start();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } catch (_) {
      showToast(message: 'بيانات الدخول غير صحيحة');
    }
  }

  /// 🔐 Google Login
  Future<void> signInWithGoogle() async {
    try {
      final provider = GoogleAuthProvider();
      final user =
      await FirebaseAuth.instance.signInWithPopup(provider);

      final uid = user.user!.uid;
      await saveUid(uid);
      shared.id_user = uid;

      await PresenceService.start();

      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } catch (_) {
      showToast(message: 'فشل تسجيل الدخول باستخدام Google');
    }
  }
}
