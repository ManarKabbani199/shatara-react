import 'dart:async';
import 'dart:convert';
import 'package:Chess_Cleverness/Widget/HomePage/CustomSectionWidget.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// يقرأ JSON من API كل 5 ثوانٍ ويعرض أحدث الصور بالتناوب
class LiveGuestImages extends StatefulWidget {
  const LiveGuestImages({super.key});

  @override
  State<LiveGuestImages> createState() => _LiveGuestImagesState();
}

class _LiveGuestImagesState extends State<LiveGuestImages> {
  // 🔁 غيّر العدد هنا إن بغيت أكثر من 5 صور
  static const int imagesLimit = 5;

  // ✅ استخدم الـPHP الجديد (limit اختياري)
  static const String apiUrl =
      'https://shatara.sa/ShataraGame/list_uploads.php?limit=$imagesLimit';

  static const refreshEvery = Duration(seconds: 5);

  Timer? _timer;
  List<String> _latest = [];
  int _index = 0;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetch();
    _timer = Timer.periodic(refreshEvery, (_) => _tick());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _tick() async {
    await _fetch();
    if (!mounted) return;
    if (_latest.length > 1) {
      setState(() => _index = (_index + 1) % _latest.length);
    }
  }

  Future<void> _fetch() async {
    try {
      final res = await http.get(Uri.parse(apiUrl));
      if (res.statusCode != 200) {
        // اطبع مقتطفًا من الجسم لتسهيل التشخيص
        final preview = res.body.length > 300 ? res.body.substring(0, 300) : res.body;
        throw Exception('HTTP ${res.statusCode}: $preview');
      }

      final decoded = json.decode(res.body);
      final list = (decoded is Map && decoded['images'] is List)
          ? (decoded['images'] as List).map((e) => e.toString()).toList()
          : <String>[];

      // تحميل مسبق لتقليل الوميض (لا تُحمّل أكثر من 20 صورة)
      for (final u in list.take(20)) {
        try {
          await precacheImage(NetworkImage(u), context);
        } catch (_) {}
      }

      if (!mounted) return;
      setState(() {
        _latest = list;
        _loading = false;
        if (_index >= _latest.length) _index = 0;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  /// لتفادي كاش المتصفح على الويب نضيف استعلام وقت للصورة فقط (ليس لطلب الـJSON)
  String _cacheBusted(String url) {
    if (!kIsWeb) return url;
    final ts = DateTime.now().millisecondsSinceEpoch;
    return url.contains('?') ? '$url&cb=$ts' : '$url?cb=$ts';
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(child: Text('خطأ: $_error'));
    }
    if (_latest.isEmpty) {
      return const Center(child: Text('لا توجد صور متاحة'));
    }

    final currentUrl = _cacheBusted(_latest[_index]);

    // لو تبيها داخل ودجتك المخصصة
    return CustomSectionWidget(
      imageProvider: NetworkImage(currentUrl),
    );
  }
}
