import 'package:flutter/material.dart';

class CustomInfoWidget extends StatelessWidget {
  const CustomInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x99FFFFFF), // 60% شفافية اللون الأبيض
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 25,),
                  // العنوان
                  SelectableText(
                    'شطارة VS الشطرنج التقليدية',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 19 : 25,
                      color: const Color(0xFF6B4E45),
                    ),
                  ),
                  const SizedBox(height: 12),

                  // التعدادات
                  _buildBulletItem('assets/icn1.png',
                      'شطارة تضيف منطقتين للدعم فيها قطع احتياطية يمكن إدخالها حسب الاستراتيجية.', isMobile),
                  _buildBulletItem('assets/icn2.png',
                      'نظام تعزيز يسمح بدخول الجنود في حال نقص العدد في الرقعة.', isMobile),
                  _buildBulletItem('assets/icn3.png',
                      'ترقية تدريجية للجندي (جندي → حصان → فيل → قلعة → وزير).', isMobile),
                  _buildBulletItem('assets/icn4.png',
                      'تصميم الرقعة مستطيل باستخدام النسبة الذهبية بدل الشكل المربع التقليدي.', isMobile),
                  _buildBulletItem('assets/icn5.png',
                      'إمكانية تبديل القطع داخل منطقة الدعم.', isMobile),
                  _buildBulletItem('assets/icn6.png',
                      'عدد القطع أكبر: 28 لكل لاعب بدل 16.', isMobile),
                ],
              ),
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
                'assets/horse.png',
                fit: BoxFit.contain,
              ),
            ),
          ),


          // القسم الثاني - العنوان والتعدادات

        ],
      ),
    );
  }

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
              textAlign: TextAlign.right,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 10 : 16,
                color: const Color(0xFF6B4E45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
