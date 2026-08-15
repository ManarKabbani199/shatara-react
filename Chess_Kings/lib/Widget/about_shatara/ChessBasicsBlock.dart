import 'package:flutter/material.dart';

class ChessBasicsBlock extends StatelessWidget {
  const ChessBasicsBlock({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Directionality(
      textDirection: TextDirection.rtl, // ✅ RTL
      child: Container
        (
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        color: const Color(0xFFAB86B9), // ✅ الخلفية
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // ✅ يمين
          children: [
            Text(
              'أساسيات الشطرنج',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 15 : 21,
                fontWeight: FontWeight.bold,
                color: Colors.white, // واضح على الخلفية
              ),
            ),
            const SizedBox(height: 15),

            Text(
              'منطقة لعب رئيسية 8×8 كما في الشطرنج',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 9 : 15,
                color: Colors.white,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 15),

            Text(
              'منطقتا دعم جانبيتان (3×4 لكل لاعب) مخصّصتان للجيش الاحتياطي',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 9 : 15,
                color: Colors.white,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 15),

            Text(
              'التصميم قائم على النسبة الذهبية لضمان توازن بصري مثالي',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 9 : 15,
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
