import 'package:flutter/material.dart';

class IntroBackground extends StatelessWidget {
  const IntroBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final bool isMobile = width < 600;
    final double fontSize = isMobile ? 17 : 21;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        constraints: const BoxConstraints(minHeight: 320),
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/aa_m.PNG'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          color: Colors.black.withOpacity(0.15),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Align(
            alignment: Alignment.centerRight, // ✅ كتلة المحتوى بمحاذاة يمين
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 900),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start, // ✅ في RTL تعني يمين
                children: [
                  Text(
                    'مقدّمة عامة',
                    textAlign: TextAlign.right, // ✅ النص نفسه يمين
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'الشطرنج أعرق لعبة استراتيجية عرفها الإنسان، تعلّمها الملوك والعباقرة وأصبحت لغة عالمية للتفكير. '
                        'وهنا نقدّم لك شطارة، النسخة المطوّرة من الشطرنج، المسجّلة ببراءة اختراع سعودية، والتي تُعيد إلى اللعبة '
                        'بُعدها الحقيقي: وجود جيش احتياطي واستراتيجية ممتدة.',
                    textAlign: TextAlign.right, // ✅ يمين
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
