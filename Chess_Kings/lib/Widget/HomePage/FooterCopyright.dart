import 'package:flutter/material.dart';

class FooterCopyright extends StatelessWidget {
  const FooterCopyright({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ✅ صورة الخط الفاصل
          Image.asset(
            'assets/Line.png',
            width: isMobile ? 80 : 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          // ✅ النص في وسط الصفحة
          SelectableText(
            'جميع الحقوق محفوظة لشطارة © 2025',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: isMobile ? 10 : 21, // ✅ حجم مناسب للجوال
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6B4E45),
            ),
          ),
        ],
      ),
    );
  }
}
