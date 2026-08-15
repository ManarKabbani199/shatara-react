import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';

class ShataraVideoTextWidget extends StatefulWidget {
  const ShataraVideoTextWidget({super.key});

  @override
  State<ShataraVideoTextWidget> createState() => _ShataraVideoTextWidgetState();
}

class _ShataraVideoTextWidgetState extends State<ShataraVideoTextWidget> {
  static const _brand = Color(0xFF6B4E45);

  VideoPlayerController? _vc;
  ChewieController? _cc;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    try {
      final vc = VideoPlayerController.asset('assets/videos/ismall.mp4');
      await vc.initialize();

      await vc.setLooping(true);
      await vc.setVolume(1.0);

      final cc = ChewieController(
        videoPlayerController: vc,
        autoPlay: !kIsWeb, // ✅ على الويب خليها false
        looping: true,
        showControls: true, // ✅ شريط تقديم/تأخير
        allowFullScreen: true,
        allowMuting: true,
      );

      if (!mounted) return;
      setState(() {
        _vc = vc;
        _cc = cc;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = true);
    }
  }

  @override
  void dispose() {
    _cc?.dispose();
    _vc?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: AspectRatio(
              aspectRatio: (_vc != null && _vc!.value.isInitialized)
                  ? _vc!.value.aspectRatio
                  : 16 / 9,
              child: _error
                  ? const Center(child: Text('تعذر تشغيل الفيديو (جرّبي MP4)'))
                  : (_cc == null)
                  ? const Center(child: CircularProgressIndicator())
                  : Chewie(controller: _cc!),
            ),
          ),
          const SizedBox(height: 12),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 7),
            child: Text(
              'شطارة لعبة ذهنية استراتيجية مبتكرة, تعتمد على بناء القرار و إدارة القوة داخل بيئة لعب منضبطة.',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: _brand,
                fontFamily: 'Alexandria',
                fontWeight: FontWeight.bold,
                fontSize: 19,
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}