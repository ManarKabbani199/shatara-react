// lib/services/presence_service.dart
import 'dart:async';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// في الويب سنستخدم dart:html لأحداث الإغلاق/الإخفاء
// لا تستوردها على غير الويب
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class PresenceService with WidgetsBindingObserver {
  PresenceService._(this.uid);
  final String uid;

  static PresenceService? _instance;

  static PresenceService? get instance => _instance;

  /// ابدأ الخدمة (Singleton)
  static Future<void> start() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;
    if (_instance != null) return;
    _instance = PresenceService._(user.uid);
    await _instance!._startInternal();
  }

  /// أوقف الخدمة ونظّف الاشتراكات
  static Future<void> stop() async {
    final svc = _instance;
    if (svc == null) return;
    await svc._stopInternal();
    _instance = null;
  }

  StreamSubscription<User?>? _authSub;

  Future<void> _startInternal() async {
    WidgetsBinding.instance.addObserver(this);

    // ✅ عند بدء التطبيق (وبما أن الجلسة محفوظة) اعتبره "متصل الآن"
    await _setOnline(true);

    // ✅ راقب تغيّر حالة المصادقة: لو فقدنا الجلسة فجأة
    _authSub = FirebaseAuth.instance.authStateChanges().listen((user) async {
      if (user == null) {
        await _setOnline(false);
      } else {
        // لو رجعت الجلسة أو تم تجديدها
        await _setOnline(true);
      }
    });

    // ✅ في الويب: عالج إغلاق التبويب/تغيير الرؤية
    if (kIsWeb) {
      // قبل إغلاق/تحديث الصفحة
      html.window.onBeforeUnload.listen((_) {
        // ملاحظة: onBeforeUnload غير منتظر، ننفذ Fire-and-forget
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'online': false,
          'lastSeen': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });

      // التبويب صار مخفي/عاد مرئي
      html.document.onVisibilityChange.listen((_) {
        final hidden = html.document.hidden ?? false;
        FirebaseFirestore.instance.collection('users').doc(uid).set({
          'online': !hidden,
          if (hidden) 'lastSeen': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      });
    }
  }

  Future<void> _stopInternal() async {
    try {
      await _setOnline(false, setLastSeen: true);
    } finally {
      WidgetsBinding.instance.removeObserver(this);
      await _authSub?.cancel();
      _authSub = null;
    }
  }

  /// حضور بسيط: on=true عند النشاط، on=false عند الخلفية/الخروج
  Future<void> _setOnline(bool on, {bool setLastSeen = false}) async {
    final ref = FirebaseFirestore.instance.collection('users').doc(uid);
    final update = <String, dynamic>{
      'online': on,
    };
    if (setLastSeen || !on) {
      update['lastSeen'] = FieldValue.serverTimestamp();
    }
    // ضمان createdAt لو ناقص (مرة واحدة)
    final snap = await ref.get();
    if (!snap.exists || !(snap.data() as Map?)!.containsKey('createdAt') == true) {
      update['createdAt'] = FieldValue.serverTimestamp();
    }
    await ref.set(update, SetOptions(merge: true));
  }

  // تطبيق/تبويب عاد نشط
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // للموبايل والدسكتوب: حدّث Online حسب الحالة
    if (state == AppLifecycleState.resumed) {
      _setOnline(true);
    } else if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive ||
        state == AppLifecycleState.detached) {
      _setOnline(false, setLastSeen: true);
    }
  }
}
