import 'dart:async';
import 'package:Chess_Cleverness/screens/ApplicationShattra/SignUpScreen.dart';
import 'package:Chess_Cleverness/screens/ApplicationShattra/auth_check_screen.dart';
import 'package:Chess_Cleverness/screens/NewHome.dart';
import 'package:Chess_Cleverness/screens/PropertyPolicyPage.dart';
import 'package:Chess_Cleverness/screens/TermsAndConditionsPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:Chess_Cleverness/shared_data.dart' as shared;

import 'firebase_options.dart';
import 'utils/storage.dart'; // saveUid / getSavedUid / clearUid

// شاشاتك

import 'package:Chess_Cleverness/screens/ConquestMapScreen.dart';
import 'package:Chess_Cleverness/screens/FAQPage.dart';
import 'package:Chess_Cleverness/screens/GamePLay/ChessBoard.dart';
import 'package:Chess_Cleverness/screens/HomePage.dart';
import 'package:Chess_Cleverness/screens/ShataraLoginScreen.dart';
import 'package:Chess_Cleverness/screens/Tweet/TwettsPublic.dart';
import 'package:Chess_Cleverness/screens/about_shatara.dart';
import 'screens/AboutPage.dart';

Future<void> main() async {
  // لفّ التطبيق بمنطقة تلتقط جميع الأخطاء غير المُلتقطة (ستطبع السبب الحقيقي بدل async_patch)
  // ملاحظة: ensureInitialized و runApp يجب أن يعملا داخل نفس الـ Zone
  runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();

    // اطبع أي خطأ Flutter غير مُلتقط
    FlutterError.onError = (FlutterErrorDetails details) {
      FlutterError.dumpErrorToConsole(details);
    };

    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // إبقاء الجلسة على الويب
    if (kIsWeb) {
      try {
        await FirebaseAuth.instance.setPersistence(Persistence.LOCAL);
      } catch (e, st) {
        // سيظهر في Console على الويب
        // ignore: avoid_print
        print('Failed to set persistence: $e\n$st');
      }
    }

    // تحميل uid في shared.id_user
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      shared.id_user = currentUser.uid;
    } else {
      final savedUid = await getSavedUid();
      if (savedUid != null && savedUid.isNotEmpty) {
        shared.id_user = savedUid;
      }
    }

    runApp(const MyApp());
  }, (error, stack) {
    // ignore: avoid_print
    print('ZONED ERROR: $error\n$stack');
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // ابدأ بصفحة Home (حسب كودك)
      home: AuthCheckScreen(),

      // إن أردت ملاحقة جميع الأخطاء داخل الشجرة أيضاً
      builder: (context, child) {
        ErrorWidget.builder = (FlutterErrorDetails details) {
          // ويدجت خطأ ودية (لا تُظهر للمستخدم النهائي في الإنتاج)
          return Material(
            color: Colors.white,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'حدث خطأ غير متوقع:\n${details.exception}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ),
          );
        };
        return child!;
      },

      routes: {
        '/main': (context) => about_Chess(),
        '/new_home': (context) => NewHome(),
        '/home': (context) => Home(),
        '/about': (context) => AboutPage(),
        '/login': (context) => ShataraLoginScreen(),
        '/signUpApp': (context) => SignUpScreen(),
        '/faq': (context) => FAQPage(),
        '/conquest': (context) => ConquestMapScreen(),
        '/playNow': (context) => ChessBoard(),
        '/about_chess': (context) => about_Chess(),
        '/Public': (context) => TweetsPublic(),
        '/PropertyPolicyPage': (context) => PropertyPolicyPage(),
        '/storyShattra': (context) => PropertyPolicyPage(),
        '/aboutn': (context) {
          final uid = shared.id_user;
          if (uid == null || uid.isEmpty) {
            // لو ما فيه UID رجّع المستخدم لـ Home (كما هو في كودك)
            return NewHome();
          }
          return NewHome();
        },
      },
    );
  }
}
