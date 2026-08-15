import 'package:flutter/material.dart';

class ChessBoardInfo extends StatelessWidget {
  const ChessBoardInfo({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Directionality(
      textDirection: TextDirection.rtl, // ✅ محاذاة لليمين
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ✅ يمين
          children: [
            Text(
              'رقعة الشطرنج :',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 15 : 21, // حجم العنوان
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 15),
            Text(
              'رقعة الشطرنج تتكوّن من شبكة مربّعة 8×8 (64 مربّعًا)، يتناوب فيها اللونان الفاتح والداكن. '
                  'يتم ترقيم الصفوف من ١ إلى 8 وترميز الأعمدة من A إلى H.',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 9 : 15, // ✅ الحجم حسب الجهاز
                fontWeight: FontWeight.normal,
                color: Colors.black,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
