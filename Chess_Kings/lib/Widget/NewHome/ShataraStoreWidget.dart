import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShataraStoreWidget extends StatelessWidget {
  const ShataraStoreWidget({super.key});

  static const _storeUrl = 'https://shatarachess.com/';

  Future<void> _openStore() async {
    final uri = Uri.parse(_storeUrl);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_storeUrl');
    }
  }

  @override
  Widget build(BuildContext context) {
    const brandColor = Color(0xFF6B4E45);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // =====================
          // الصف الأول
          // =====================
          Row(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(width: 7,),
                      Image.asset(
                        'assets/iconh.png',
                        height: 25,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'متجر شطاره',
                        style: TextStyle(
                          color: brandColor,
                          fontFamily: 'Alexandria',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: InkWell(
                    onTap: _openStore,
                    child: Image.asset(
                      'assets/btnstore.png',
                      height: 35,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 7,),
            ],
          ),

          const SizedBox(height: 10),

          // =====================
          // الصف الثاني (4 صور جنب بعض)
          // =====================
          Row(
            children: [
              Expanded(child: Image.asset('assets/st1.png', fit: BoxFit.contain)),
              const SizedBox(width: 6),
              Expanded(child: Image.asset('assets/st2.png', fit: BoxFit.contain)),
              const SizedBox(width: 6),
              Expanded(child: Image.asset('assets/st3.png', fit: BoxFit.contain)),
              const SizedBox(width: 6),
              Expanded(child: Image.asset('assets/st4.png', fit: BoxFit.contain)),
            ],
          ),
        ],
      ),
    );
  }
}