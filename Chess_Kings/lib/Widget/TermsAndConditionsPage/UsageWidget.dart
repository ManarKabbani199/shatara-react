import 'package:flutter/material.dart';

class UsageWidget extends StatelessWidget {
  final String title;       // العنوان
  final String description; // النص الأساسي
  final String iconPath;    // مسار الأيقونة
  final List<String> bullets; // قائمة التعدادات

  const UsageWidget({
    super.key,
    required this.title,
    required this.description,
    required this.iconPath,
    required this.bullets,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    const bg = Color(0xFFE5E7EB);
    const textColor = Color(0xFF6B4E45);

    final titleSize = isMobile ? 17.0 : 21.0;
    final bodySize  = isMobile ? 11.0 : 14.0;
    final bulletSize = isMobile ? 9.0 : 12.0;

    Widget bulletItem(String text) {
      return Padding(
        padding: const EdgeInsets.only(top: 6),
        child: Row(
          textDirection: TextDirection.rtl,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SelectableText('• ', style: TextStyle(height: 1.4)),
            Expanded(
              child: SelectableText(
                text,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: bulletSize,
                  color: textColor,
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Directionality(
      textDirection: TextDirection.rtl, // لضبط الاتجاه كامل
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: bg,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // كله يمين
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  iconPath,
                  width: isMobile ? 24 : 28,
                  height: isMobile ? 24 : 28,
                ),
                const SizedBox(width: 8),
                SelectableText(
                  title,
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontWeight: FontWeight.bold,
                    fontSize: titleSize,
                    color: textColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SelectableText(
              description,
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: bodySize,
                color: textColor,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 6),
            ...bullets.map(bulletItem),
          ],
        ),
      ),
    );
  }
}
