import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../HomePage.dart';
import 'ForgotPasswordScreen.dart';
import 'SignUpScreen.dart';


enum AuthTab { login, signup }

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool rememberMe = true;
  bool obscurePassword = true;
  bool isLoading = false;
  AuthTab selectedTab = AuthTab.login;

  static const Color backgroundColor = Color(0xFFF5F5F5);
  static const Color primaryColor = Color(0xFFB18BC3);
  static const Color textColor = Color(0xFF7A5E57);
  static const Color borderColor = Color(0xFFD7D2D0);
  static const Color hintColor = Color(0xFFB8AAA4);

  @override
  void initState() {
    super.initState();
    _loadRememberedData();
  }

  Future<void> _loadRememberedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedRememberMe = prefs.getBool('remember_me') ?? false;
    final savedEmail = prefs.getString('saved_email') ?? '';

    setState(() {
      rememberMe = savedRememberMe;
      if (savedRememberMe) {
        emailController.text = savedEmail;
      }
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> loginUser() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      _showMessage('يرجى إدخال البريد الإلكتروني');
      return;
    }

    if (password.isEmpty) {
      _showMessage('يرجى إدخال كلمة المرور');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: email)
          .where('password', isEqualTo: password)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        _showMessage('البريد الإلكتروني أو كلمة المرور غير صحيحة');
        return;
      }

      final userDoc = querySnapshot.docs.first;
      final userData = userDoc.data();

      if (userData['isBanned'] == true) {
        _showMessage('هذا الحساب محظور');
        return;
      }

      await userDoc.reference.update({
        'online': true,
        'login': '1',
      });

      final prefs = await SharedPreferences.getInstance();

      if (rememberMe) {
        await prefs.setBool('remember_me', true);
        await prefs.setString('saved_email', email);
        await prefs.setString('logged_user_uid', userData['uid'] ?? '');
      } else {
        await prefs.setBool('remember_me', false);
        await prefs.remove('saved_email');
        await prefs.remove('logged_user_uid');
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } catch (e) {
      _showMessage('حدث خطأ أثناء تسجيل الدخول');
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.right,
          style: const TextStyle(fontFamily: 'Alexandria'),
        ),
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
                    Column(
                      children: [
                        Image.asset(
                          'assets/logoapp.png',
                          height: 120,
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Center(
                      child: Text(
                        'مرحباً بعودتك!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                          fontFamily: 'Alexandria',
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),

                    Container(
                      height: 58,
                      decoration: BoxDecoration(
                        border: Border.all(color: borderColor),
                        color: Colors.white,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildTabButton(
                              title: 'إنشاء حساب',
                              isSelected: selectedTab == AuthTab.signup,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SignUpScreen(),
                                  ),
                                );
                              },
                            ),
                          ),
                          Expanded(
                            child: _buildTabButton(
                              title: 'تسجيل الدخول',
                              isSelected: selectedTab == AuthTab.login,
                              onTap: () {
                                setState(() {
                                  selectedTab = AuthTab.login;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 34),

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

                    _buildTextField(
                      controller: emailController,
                      hintText: 'البريد الإلكتروني',
                      obscureText: false,
                      suffixIcon: Icons.mail_outline,
                    ),

                    const SizedBox(height: 24),

                    const Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        'كلمة المرور',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Alexandria',
                          color: textColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),

                    _buildTextField(
                      controller: passwordController,
                      hintText: 'كلمة المرور',
                      obscureText: obscurePassword,
                      suffixIcon: Icons.lock_outline,
                      prefixIcon: obscurePassword
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      onPrefixTap: () {
                        setState(() {
                          obscurePassword = !obscurePassword;
                        });
                      },
                    ),

                    const SizedBox(height: 10),

                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ForgotPasswordScreen(),
                              ),
                            );
                          },
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: 'Alexandria',
                              color: primaryColor,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Text(
                              'تذكرني',
                              style: TextStyle(
                                fontSize: 15,
                                fontFamily: 'Alexandria',
                                color: primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 8),
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: rememberMe,
                                activeColor: primaryColor,
                                side: const BorderSide(color: primaryColor),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    rememberMe = value ?? false;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    SizedBox(
                      height: 56,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : loginUser,
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
                          'تسجيل الدخول',
                          style: TextStyle(
                            fontSize: 18,
                            fontFamily: 'Alexandria',
                            fontWeight: FontWeight.w700,
                          ),
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

  Widget _buildTabButton({
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        color: isSelected ? primaryColor : Colors.white,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            fontFamily: 'Alexandria',
            color: isSelected ? Colors.white : textColor,
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required bool obscureText,
    required IconData suffixIcon,
    IconData? prefixIcon,
    VoidCallback? onPrefixTap,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      textAlign: TextAlign.right,
      style: const TextStyle(
        fontSize: 13,
        color: textColor,
        fontFamily: 'Alexandria',
      ),
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        hintText: hintText,
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
        suffixIcon: Icon(
          suffixIcon,
          color: textColor,
        ),
        prefixIcon: prefixIcon != null
            ? IconButton(
          onPressed: onPrefixTap,
          icon: Icon(
            prefixIcon,
            color: textColor,
          ),
        )
            : null,
      ),
    );
  }
}