import 'package:flutter/material.dart';

class ShataraOverview extends StatelessWidget {
  const ShataraOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final double titleFontSize = isMobile ? 15 : 25;
    final double columnTextSize = isMobile ? 10 : 15;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF).withOpacity(0.6), // ✅ خلفية شفافة
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // ✅ القسم الأول - النص
          SelectableText(
            "شطارة هي تطوير سعودي مبتكر للعبة الشطرنج، تحافظ على القواعد الأساسية لكنها تضيف عمقًا استراتيجيًا من خلال",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: titleFontSize,
              color: const Color(0xFF6B4E45),
            ),
          ),

          const SizedBox(height: 24),

          // ✅ القسم الثاني - الأعمدة الأربعة
          isMobile
              ? Column( // في الموبايل أعمدة عمودية
            children: _buildFeatureColumns(columnTextSize, true),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buildFeatureColumns(columnTextSize, false),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildFeatureColumns(double fontSize, bool isMobile) {
    final List<Map<String, String>> features = [
      {"image": "assets/daaa.jpg", "text": "مناطق دعم إحتياطية"},
      {"image": "assets/tazzz.PNG", "text": "نظام تعزيز ذكي"},
      {"image": "assets/trkya.PNG", "text": "ترقية تدريجية للقطع"},
      {"image": "assets/gold.PNG", "text": "تصميم بصري مسند للنسبة الذهبية"},
    ];

    return features
        .map(
          (feature) => Padding(
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 0 : 12,
          vertical: isMobile ? 12 : 0,
        ),
        child: Column(
          children: [
            Image.asset(feature["image"]!, width: 50, height: 50),
            const SizedBox(height: 8),
            SelectableText(
              feature["text"]!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
                color: const Color(0xFF6B4E45),
              ),
            ),
            const SizedBox(height: 4),
            Container(
              width: 40,
              height: 1,
              color: Colors.black,
            ),
          ],
        ),
      ),
    )
        .toList();
  }
}
