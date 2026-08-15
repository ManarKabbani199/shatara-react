import 'package:flutter/material.dart';

class TermsWidget extends StatelessWidget {
  const TermsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // العنوان الرئيسي
            SelectableText(
              'مصطلحات شطارة - تعريفات سريعة',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 18 : 24,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4E45),
              ),
            ),
            const SizedBox(height: 16),

            // قائمة العناصر القابلة للفتح
            _buildTile(
              title: 'منطقة الدعم',
              content: 'يمنحك اختيار حركة احتياطية تُفعل في اللحظة المناسبة لتنفيذ الموقف لصالحك.',
            ),
            _buildTile(title: 'التعزيز', content: ''),
            _buildTile(title: 'الترقية التدريجية', content: ''),
            _buildTile(title: 'التبديل', content: ''),

            const SizedBox(height: 24),

            // صندوق التنبيه
            SizedBox(
              width: double.infinity,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFA32B37),
                ),
                child: SelectableText(
                  'ممنوع التهديد المباشر، لا يسمح بإدخال قطعة أو ترقيتها إن كانت تهدد الملك فوراً',
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    fontSize: isMobile ? 13 : 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // تابع مساعد لبناء ExpansionTile
  Widget _buildTile({required String title, required String content}) {
    return Card(
      elevation: 1,
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 16),
        collapsedBackgroundColor: const Color(0xFFF5F5F5),
        backgroundColor: const Color(0xFFF9F9F9),
        title: SelectableText(
          title,
          style: const TextStyle(
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        children: content.isNotEmpty
            ? [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: SelectableText(
              content,
              style: const TextStyle(
                fontFamily: 'Alexandria',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        ]
            : [],
      ),
    );
  }
}
