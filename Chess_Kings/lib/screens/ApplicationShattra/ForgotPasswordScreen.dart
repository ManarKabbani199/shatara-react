import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController emailController = TextEditingController();
  bool isLoading = false;

  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color primaryColor = Color(0xFFB18BC3);
  static const Color textColor = Color(0xFF7A5E57);
  static const Color borderColor = Color(0xFFD7D2D0);
  static const Color hintColor = Color(0xFFB8AAA4);

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  Future<void> resetPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      _showDialogMessage(
        title: 'تنبيه',
        message: 'يرجى إدخال البريد الإلكتروني',
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);

      if (!mounted) return;

      _showDialogMessage(
        title: 'تم بنجاح',
        message:
        'تم إرسال رابط إعادة تعيين كلمة المرور إلى بريدك الإلكتروني.\nيرجى التحقق من صندوق الوارد أو الرسائل غير المرغوب فيها.',
        onOk: () {
          Navigator.pop(context); // يرجع إلى صفحة تسجيل الدخول
        },
      );
    } on FirebaseAuthException catch (e) {
      String message = 'حدث خطأ، حاول مرة أخرى';

      if (e.code == 'user-not-found') {
        message = 'هذا البريد غير مسجل';
      } else if (e.code == 'invalid-email') {
        message = 'صيغة البريد الإلكتروني غير صحيحة';
      } else if (e.code == 'too-many-requests') {
        message = 'تمت محاولات كثيرة، حاول لاحقًا';
      }

      _showDialogMessage(
        title: 'تعذر الإرسال',
        message: message,
      );
    } catch (e) {
      _showDialogMessage(
        title: 'خطأ',
        message: 'حدث خطأ غير متوقع',
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showDialogMessage({
    required String title,
    required String message,
    VoidCallback? onOk,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.w700,
            color: textColor,
            fontSize: 18,
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            color: textColor,
            fontSize: 14,
            height: 1.7,
          ),
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              if (onOk != null) onOk();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: const Text(
              'حسنًا',
              style: TextStyle(fontFamily: 'Alexandria'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: Image.asset(
                        'assets/logoapp.png',
                        height: 110,
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 28),
                    const Text(
                      'استعادة كلمة المرور',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: textColor,
                        fontFamily: 'Alexandria',
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'أدخل بريدك الإلكتروني وسنرسل لك رابطًا لإعادة تعيين كلمة المرور.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 14,
                        color: textColor,
                        fontFamily: 'Alexandria',
                        height: 1.8,
                      ),
                    ),
                    const SizedBox(height: 32),
                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'البريد الإلكتروني',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Alexandria',
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      textAlign: TextAlign.right,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(
                        fontSize: 13,
                        color: textColor,
                        fontFamily: 'Alexandria',
                      ),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'البريد الإلكتروني',
                        hintStyle: const TextStyle(
                          color: hintColor,
                          fontSize: 13,
                          fontFamily: 'Alexandria',
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 18,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: borderColor),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: primaryColor),
                          borderRadius: BorderRadius.circular(0),
                        ),
                        suffixIcon: const Icon(
                          Icons.mail_outline,
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : resetPassword,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2.5,
                          ),
                        )
                            : const Text(
                          'إرسال رابط الاستعادة',
                          style: TextStyle(
                            fontSize: 17,
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        'العودة إلى تسجيل الدخول',
                        style: TextStyle(
                          color: primaryColor,
                          fontFamily: 'Alexandria',
                          fontWeight: FontWeight.w600,
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
    );
  }
}