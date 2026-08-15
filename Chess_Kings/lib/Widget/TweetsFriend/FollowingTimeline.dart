// lib/Widget/TweetsFriend/FollowingTimeline.dart
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter/material.dart';

import '../../models/tweet_model.dart';     // عدّل المسار حسب مشروعك إن لزم
import '../TweetsPage/TweetTile.dart';      // عدّل المسار حسب مشروعك إن لزم

class FollowingTimeline extends StatefulWidget {
  /// نص البحث داخل التغريدات
  final String searchQuery;

  /// تضمين تغريدات المستخدم نفسه في الخط الزمني
  final bool includeCurrentUser;

  /// اسم حقل صاحب التغريدة داخل مستند التغريدة (مثلاً 'userId' أو 'uid')
  final String userField;

  /// اسم حقل النوع داخل التغريدة (مثلاً 'type')
  final String typeField;

  /// القيم المراد عرضها للنوع (افتراضياً: tweet + retweet)
  final List<String> typeValues;

  /// تفعيل طباعة سجلات تشخيصية
  final bool enableDebugLogs;

  /// Widgets مخصصة للحالات (تحميل/فارغ)
  final Widget Function(BuildContext context)? loadingBuilder;
  final Widget Function(BuildContext context)? emptyBuilder;

  const FollowingTimeline({
    super.key,
    this.searchQuery = '',
    this.includeCurrentUser = true,
    this.userField = 'userId',
    this.typeField = 'type',
    this.typeValues = const ['tweet', 'retweet'],
    this.enableDebugLogs = false,
    this.loadingBuilder,
    this.emptyBuilder,
  });

  @override
  State<FollowingTimeline> createState() => _FollowingTimelineState();
}

class _FollowingTimelineState extends State<FollowingTimeline> {
  StreamSubscription<List<String>>? _followingSub;
  StreamSubscription<List<TweetModel>>? _tweetsSub;

  List<String> _currentFollowing = const [];
  List<TweetModel> _cache = const [];     // آخر نتيجة غير فارغة
  bool _hasEverEmitted = false;           // هل وصلتنا أي بيانات من قبل؟
  bool _loading = true;                   // حالة التحميل الحالية
  Timer? _emptyGraceTimer;                // مهلة قصيرة قبل مسح الكاش لمنع الوميض

  @override
  void initState() {
    super.initState();
    _startFollowingWatcher();
  }

  @override
  void dispose() {
    _followingSub?.cancel();
    _tweetsSub?.cancel();
    _emptyGraceTimer?.cancel();
    super.dispose();
  }

  void _startFollowingWatcher() {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      setState(() {
        _loading = false;
        _cache = const [];
        _hasEverEmitted = true; // لعرض empty مباشرة
      });
      return;
    }
    final uid = user.uid;

    final followingStream = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .map((snap) {
      final data = snap.data() as Map<String, dynamic>? ?? {};
      final raw = (data['following'] as List?) ?? const [];
      final ids = <String>[];
      for (final e in raw) {
        if (e is String && e.trim().isNotEmpty) {
          ids.add(e);
        } else if (e is Map) {
          for (final k in ['uid', 'userId', 'id']) {
            final v = e[k];
            if (v is String && v.trim().isNotEmpty) {
              ids.add(v);
              break;
            }
          }
        }
      }
      if (widget.includeCurrentUser && !ids.contains(uid)) {
        ids.add(uid);
      }
      // ⭐ فرز لكي تكون المقارنة غير حسّاسة للترتيب
      ids.sort();
      return ids;
    })
    // مقارنة order-insensitive (بعد الفرز تصبح listEquals كافية)
        .distinct((a, b) => listEquals(a, b));

    _followingSub = followingStream.listen((ids) {
      if (widget.enableDebugLogs) {
        debugPrint('[FollowingTimeline] followingIds(${ids.length}): $ids');
      }
      _currentFollowing = ids;
      _rebuildTweetsStream(); // كلما تغيّرت القائمة نبني ستريم التغريدات
    });
  }

  void _rebuildTweetsStream() {
    _tweetsSub?.cancel();
    _emptyGraceTimer?.cancel();

    if (_currentFollowing.isEmpty) {
      // لا تمسح الكاش فوراً، اعطِ مهلة قصيرة لتفادي الوميض
      _scheduleEmptyAfterGrace();
      return;
    }

    final combined = _buildCombinedTweetsStream(
      ids: _currentFollowing,
      userField: widget.userField,
      typeField: widget.typeField,
      typeValues: widget.typeValues,
      log: widget.enableDebugLogs,
    );

    setState(() {
      _loading = true;
    });

    _tweetsSub = combined.listen((tweets) {
      // فلترة البحث
      final q = widget.searchQuery.toLowerCase().trim();
      final filtered = q.isEmpty
          ? tweets
          : tweets.where((t) {
        final text = (t.text).toLowerCase();
        return text.contains(q) || text.contains('#$q');
      }).toList();

      if (filtered.isNotEmpty) {
        // تحديث الكاش فوراً عند وجود بيانات
        setState(() {
          _cache = filtered;
          _hasEverEmitted = true;
          _loading = false;
        });
        _emptyGraceTimer?.cancel();
      } else {
        // لا تمسح الكاش فوراً؛ أعطِ مهلة 700ms قبل إظهار "لا توجد"
        setState(() {
          _loading = false;
        });
        _scheduleEmptyAfterGrace();
      }

      if (widget.enableDebugLogs) {
        debugPrint('[FollowingTimeline] merged=${tweets.length}, filtered=${filtered.length}');
      }
    }, onError: (e) {
      if (widget.enableDebugLogs) {
        debugPrint('[FollowingTimeline] stream error: $e');
      }
      // في حال الخطأ لا نمسح الكاش، فقط نوقف التحميل
      setState(() => _loading = false);
    });
  }

  void _scheduleEmptyAfterGrace() {
    _emptyGraceTimer?.cancel();
    _emptyGraceTimer = Timer(const Duration(milliseconds: 700), () {
      // بعد المهلة، إن لم تصل بيانات جديدة، نفرّغ الكاش
      setState(() {
        _cache = const [];
        _hasEverEmitted = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading && _cache.isEmpty) {
      return widget.loadingBuilder?.call(context) ??
          const Center(child: CircularProgressIndicator());
    }

    if (_cache.isEmpty) {
      // لا توجد بيانات في الكاش بعد المهلة
      return widget.emptyBuilder?.call(context) ??
          const Center(child: Text('لا توجد مشاركات.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: _cache.length,
      itemBuilder: (context, i) => TweetTile(tweet: _cache[i]),
    );
  }
}

/// يبني ستريم يدمج نتائج عدّة استعلامات:
/// - تقسيم ids إلى كتل من 10 (حد whereIn)
/// - لكل كتلة: where(userField in chunk) + where(typeField in typeValues) + orderBy(timestamp desc)
/// - دمج النتائج وإزالة التكرار ثم ترتيبها
Stream<List<TweetModel>> _buildCombinedTweetsStream({
  required List<String> ids,
  required String userField,
  required String typeField,
  required List<String> typeValues,
  bool log = false,
}) {
  // تقسيم ids
  final chunks = _chunksOf(ids, 10);

  final streams = chunks.map((chunk) {
    Query q = FirebaseFirestore.instance
        .collection('tweets')
        .where(userField, whereIn: chunk);

    if (typeValues.isNotEmpty) {
      q = q.where(typeField, whereIn: typeValues);
    }

    q = q.orderBy('timestamp', descending: true);

    return q.snapshots().map((qs) {
      final items = <TweetModel>[];
      for (final d in qs.docs) {
        final raw = d.data() as Map<String, dynamic>;

        raw['userId'] ??= raw[userField];
        raw['timestamp'] ??= Timestamp.fromDate(DateTime.fromMillisecondsSinceEpoch(0));

        try {
          final m = TweetModel.fromMap(raw, id: d.id);
          items.add(m);
        } catch (_) {}
      }
      return items;
    });
  }).toList();

  // ادمج كل الاستعلامات معًا: عند أي تحديث في أي استعلام نُعيد دمج الكل
  return _combineLatest<List<TweetModel>>(streams).map((lists) {
    final merged = <TweetModel>[];
    for (final l in lists) {
      merged.addAll(l);
    }
    // إزالة التكرار بنفس id
    final byId = {for (final t in merged) t.id: t};
    final unique = byId.values.toList();
    // ترتيب تنازلي حسب الوقت
    unique.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return unique;
  });
}

/// دمج قائمة Streams<T> إلى Stream<List<T>>:
/// لا يُصدر قيمة حتى تصل أول قيمة من جميع الاستريمات، ثم يحدّث عند أي تغيّر.
Stream<List<T>> _combineLatest<T>(List<Stream<T>> streams) async* {
  if (streams.isEmpty) {
    yield <T>[]; // ✅ لا تستخدم const مع generics
    return;
  }

  final controller = StreamController<List<T>>();
  final latest = List<T?>.filled(streams.length, null, growable: false);
  int ready = 0;

  final subs = <StreamSubscription<T>>[];

  void tryEmit() {
    if (ready == streams.length) {
      controller.add(latest.cast<T>().toList(growable: false));
    }
  }

  for (var i = 0; i < streams.length; i++) {
    final sub = streams[i].listen((val) {
      if (latest[i] == null) ready += 1;
      latest[i] = val;
      tryEmit();
    }, onError: controller.addError);
    subs.add(sub);
  }

  yield* controller.stream;

  for (final s in subs) {
    await s.cancel();
  }
  await controller.close();
}

List<List<T>> _chunksOf<T>(List<T> list, int size) {
  final out = <List<T>>[];
  for (var i = 0; i < list.length; i += size) {
    out.add(list.sublist(i, i + size > list.length ? list.length : i + size));
  }
  return out;
}
