import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../GamePLay/ChessBoard.dart';
import '../HomePage.dart';
import '../NewHome.dart';
import 'LoginScreen.dart';
import 'SignUpScreen.dart';

class AuthCheckScreen extends StatefulWidget {
  const AuthCheckScreen({super.key});

  @override
  State<AuthCheckScreen> createState() => _AuthCheckScreenState();
}

class _AuthCheckScreenState extends State<AuthCheckScreen> {
  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;
    final uid = prefs.getString('logged_user_uid') ?? '';

    if (!mounted) return;

    // Don't hijack deep links: if the app was opened on a specific route
    // (e.g. /#/conquest), that route is already on top of us — leave it.
    if (ModalRoute.of(context)?.isCurrent != true) return;

    if (rememberMe && uid.isNotEmpty) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ChessBoard()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ChessBoard()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}