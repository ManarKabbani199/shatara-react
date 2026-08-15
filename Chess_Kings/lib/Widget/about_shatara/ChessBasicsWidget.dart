import 'package:flutter/material.dart';

class ChessBasicsWidget extends StatelessWidget {
  final String title;   // ✅ العنوان متحول
  final String content; // ✅ النص متحول

  const ChessBasicsWidget({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Directionality(
      textDirection: TextDirection.rtl, // ✅ يضمن الكتابة من اليمين
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: const Color(0xFFAB86B9), // الخلفية
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ✅ المحاذاة يمين
          children: [
            Text(
              title, // ✅ متغير
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 15 : 21,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 15), // ✅ تباعد 15
            Text(
              content, // ✅ متغير
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 9 : 15,
                fontWeight: FontWeight.normal,
                color: Colors.white,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
