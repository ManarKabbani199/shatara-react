import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
// موبايل:
import 'package:video_player/video_player.dart';
// ويب:
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

class AdaptiveVideo extends StatelessWidget {
  final String url;
  const AdaptiveVideo({super.key, required this.url});

  @override
  Widget build(BuildContext context) {
    return kIsWeb ? _WebVideo(url: url) : _MobileVideo(url: url);
  }
}

// --------- WEB ----------
class _WebVideo extends StatefulWidget {
  final String url;
  const _WebVideo({required this.url});

  @override
  State<_WebVideo> createState() => _WebVideoState();
}

class _WebVideoState extends State<_WebVideo> {
  late final String _viewType;
  late final html.VideoElement _video;
  String? _err;

  String _guessMime(String u) {
    final url = u.toLowerCase();
    if (url.endsWith('.mp4')) return 'video/mp4';
    if (url.endsWith('.webm')) return 'video/webm';
    if (url.endsWith('.mov')) return 'video/quicktime';
    if (url.endsWith('.m4v')) return 'video/x-m4v';
    if (url.endsWith('.mkv')) return 'video/x-matroska';
    return 'video/mp4';
  }

  @override
  void initState() {
    super.initState();
    _viewType = 'video-${DateTime.now().microsecondsSinceEpoch}';

    _video = html.VideoElement()
      ..src = widget.url
      ..controls = true
      ..autoplay = false
      ..loop = true
      ..preload = 'metadata'
      ..setAttribute('playsinline', 'true')
      ..style.width = '100%'
      ..style.height = '100%';

    final source = html.SourceElement()
      ..src = widget.url
      ..type = _guessMime(widget.url);
    _video.children = [source];

    _video.onError.listen((_) {
      _err = _video.error?.message ?? 'MEDIA_ELEMENT_ERROR';
      // ignore: avoid_print
      print('WEB VIDEO ERROR: $_err');
      if (mounted) setState(() {});
    });

    ui_web.platformViewRegistry.registerViewFactory(
      _viewType,
          (int viewId) => _video,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_err != null) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text(
          'تعذّر تشغيل الفيديو على الويب:\n$_err\n'
              'تأكد من MP4 (H.264/AAC) ورؤوس السيرفر (Accept-Ranges, Content-Type).',
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.red),
        ),
      );
    }
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: HtmlElementView(viewType: _viewType), // ← الودجت الأصلي مباشرة
    );
  }
}

// --------- MOBILE ----------
class _MobileVideo extends StatefulWidget {
  final String url;
  const _MobileVideo({required this.url});

  @override
  State<_MobileVideo> createState() => _MobileVideoState();
}

class _MobileVideoState extends State<_MobileVideo> {
  late final VideoPlayerController _controller;
  String? _err;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.networkUrl(Uri.parse(widget.url))
      ..addListener(() {
        final v = _controller.value;
        if (v.hasError) {
          // ignore: avoid_print
          print('VIDEO ERROR: ${v.errorDescription}');
          if (mounted) setState(() => _err = v.errorDescription);
        }
      })
      ..initialize().then((_) {
        if (!mounted) return;
        setState(() {});
        _controller.setLooping(true);
      }).catchError((e, st) {
        // ignore: avoid_print
        print('Video init failed: $e\n$st');
        if (mounted) setState(() => _err = 'Init failed: $e');
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_err != null) {
      return Padding(
        padding: const EdgeInsets.all(8),
        child: Text('تعذّر تشغيل الفيديو:\n$_err',
            textAlign: TextAlign.center, style: const TextStyle(color: Colors.red)),
      );
    }
    if (!_controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator());
    }
    final ar = _controller.value.aspectRatio == 0 ? 16 / 9 : _controller.value.aspectRatio;
    return AspectRatio(aspectRatio: ar, child: VideoPlayer(_controller));
  }
}
