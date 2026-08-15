// lib/services/logout_service.dart
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../services/presence_service.dart'; // PresenceService.start/stop
import '../utils/storage.dart';              // clearUid
import '../shared_data.dart' as shared;      // shared.id_user

class LogoutService {
  /// تسجيل الخروج الموحد لجميع الصفحات
  static Future<void> signOut(
      BuildContext context, {
        String redirectRoute = '/main',
      }) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;

    try {
      // 1) حدّث الحالة قبل signOut (حتى لا نفقد uid)
      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'online': false,
          'lastSeen': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }

      // 2) أوقف حضور التطبيق
      await PresenceService.stop();

      // 3) لو موبايل، سجّل خروج Google أيضًا
      if (!kIsWeb) {
        try { await GoogleSignIn().signOut(); } catch (_) {}
      }

      // 4) تسجيل الخروج من Firebase
      await FirebaseAuth.instance.signOut();

      // 5) تنظيف الهوية المحلية
      await clearUid();
      shared.id_user = '';

      // 6) التوجيه
      if (!context.mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, redirectRoute, (route) => false);
    } catch (e) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل تسجيل الخروج: $e')),
      );
    }
  }

  /// (اختياري) نافذة تأكيد قبل تسجيل الخروج
  static Future<void> confirmAndSignOut(BuildContext context, {String redirectRoute = '/main'}) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تأكيد الخروج'),
        content: const Text('هل تريد تسجيل الخروج؟'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('إلغاء')),
          ElevatedButton(onPressed: () => Navigator.pop(context, true), child: const Text('خروج')),
        ],
      ),
    );
    if (ok == true) {
      await signOut(context, redirectRoute: redirectRoute);
    }
  }
}
