import 'package:flutter/material.dart';

class SupportAreaWidget extends StatelessWidget {
  const SupportAreaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withOpacity(0.6), // ✅ خلفية شفافة
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // القسم الأول: العنوان
        SelectableText(
          'منطقة الدعم',
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 20 : 29,
            color: const Color(0xFF6B4E45),
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 16),

        // القسم الثاني: صورة الشطرنج
        Center(
          child: Image.asset(
            'assets/shatraBord.png',
            fit: BoxFit.contain,
          ),
        ),

        const SizedBox(height: 16),

        // القسم الثالث: النص التوضيحي
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SelectableText(
              'كل لاعب عنده منطقة دعم مكونة من 12 مربعًا، وتوضع فيها:',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 11 : 19,
                color: const Color(0xFF6B4E45),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // القسم الرابع: صورة Grid
        Center(
          child: Image.asset(
            'assets/Grip1.png',
            fit: BoxFit.contain,
          ),
        ),
      ],
    ),
    );
  }
}
