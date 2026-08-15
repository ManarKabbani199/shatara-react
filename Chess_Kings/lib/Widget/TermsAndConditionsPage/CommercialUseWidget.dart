import 'package:flutter/material.dart';

class CommercialUseWidget extends StatelessWidget {
  final String backgroundPath; // مسار الخلفية
  final String message;        // النص

  const CommercialUseWidget({
    super.key,
    this.backgroundPath = 'assets/backb.png',
    this.message = 'للاستخدام التجاري: يرجى التواصل معنا للحصول على ترخيص مناسب قبل استخدام أي محتوى لأغراض تجارية.',
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 600;

    const textColor = Color(0xFF193CB8);
    final fontSize = isMobile ? 15.0 : 11.0; // حسب طلبك: 7 دِسكتوب / 9 موبايل

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(backgroundPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // محاذاة يمين
          children: [
            Padding(
              padding: const EdgeInsets.all(3.0),
              child: SelectableText(
                message,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.w700, // Bold
                  fontSize: fontSize,
                  color: textColor,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
