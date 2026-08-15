import 'package:flutter/material.dart';

class CustomInfoNewWidget extends StatelessWidget {
  const CustomInfoNewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    final textStyle = TextStyle(
      fontFamily: 'Alexandria',
      fontSize: isMobile ? 12 : 19,
      color: Colors.white,
      fontWeight: FontWeight.bold,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x99FFFFFF), // خلفية شفافة
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصف الأول: صورة ومحتوى
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // النصوص
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 25),
                      SelectableText(
                        'تبديل وتغيير القطع (داخل منطقة الدعم)',
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 19 : 25,
                          color: const Color(0xFF6B4E45),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // التعدادات
                      _buildBulletItem(
                        'assets/icn1.png',
                        'يمكن تبديل القطع عند الترقية إذا كانت القطعة التالية متوفرة في منطقة الدعم.',
                        isMobile,
                      ),
                      _buildBulletItem(
                        'assets/icn2.png',
                        'لا يتم التبديل في الرقعة مباشرة، يجب نقل القطعة إلى منطقة الدعم ثم استبدالها.',
                        isMobile,
                      ),
                      _buildBulletItem(
                        'assets/icn3.png',
                        'يتم ذلك وفق الترقية التدريجية.',
                        isMobile,
                      ),
                      _buildBulletItem(
                        'assets/icn4.png',
                        'يُحسب هذا التبديل كنقلة مستقلة.',
                        isMobile,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Container(
                    constraints: BoxConstraints(
                      maxHeight: isMobile ? 120 : 220, // تقليل ارتفاع الصورة
                      maxWidth: isMobile ? 100 : 180,  // تقليل عرض الصورة
                    ),
                    child: Image.asset(
                      'assets/tazzz.PNG',
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            // عنوان الملاحظات
            SelectableText(
              'ملاحظات مهمة',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontWeight: FontWeight.bold,
                fontSize: isMobile ? 19 : 25,
                color: const Color(0xFF6B4E45),
              ),
            ),
            const SizedBox(height: 12),

            // الملاحظات داخل خلفية
        Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            children: [
              _buildBox('يُستخدم الدعم للهجوم أو لتعويض الخسائر.', textStyle),
              _buildDivider(),
              _buildBox('القطع في الدعم لا تؤثر على اللعب حتى يتم إدخالها للرقعة.', textStyle),
              _buildDivider(),
              _buildBox('عند الترقية، تُستخدم القطع من هذه المنطقة.', textStyle),
            ],
          ),
        ),


          ],
        ),
      ),
    );
  }


  Widget _buildBox(String text, TextStyle style) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        height: 95,
        decoration: BoxDecoration(
          color: const Color(0xFFA32B37),
        ),
        child: SelectableText(
          text,
          style: style,
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 6,
      height: 60,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  // تابع التعداد
  Widget _buildBulletItem(String iconPath, String text, bool isMobile) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            iconPath,
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SelectableText(
              text,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 10 : 16,
                color: const Color(0xFF6B4E45),
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
