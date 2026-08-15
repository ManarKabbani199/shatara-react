import 'package:flutter/material.dart';

class FaqSection extends StatelessWidget {
  const FaqSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    final faqList = [
      {
        'question': 'كيف يعمل نظام الإحتياط؟',
        'answer': 'يتيح لك اختيار حركة احتياطية تُفعل في اللحظة المناسبة لتقيد الموقف لصالحك.'
      },
      {
        'question': 'هل هناك اشتراك شهري؟',
        'answer': 'لا يوجد اشتراك شهري حالياً، بل يتم الدفع حسب نوع المشاركة أو الاشتراك الموسمي.'
      },
      {
        'question': 'كيف أشارك في البطولات؟',
        'answer': 'يمكنك التسجيل عبر قسم "البطولات" في المنصة واختيار الفئة التي تناسب مستواك.'
      },
    ];

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
      color: const Color(0xFFF3F3F2),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'الأسئلة الشائعة - FAQ',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 22 : 28,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4E45),
              ),
            ),
            const SizedBox(height: 30),
            ...faqList.map((faq) => _buildFaqTile(faq['question']!, faq['answer']!, isMobile)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFaqTile(String question, String answer, bool isMobile) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        collapsedBackgroundColor: const Color(0xFFDDDDDC),
        backgroundColor: const Color(0xFFAB86B9), // ✅ اللون النشط للسؤال المفتوح
        title: Text(
          question,
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: isMobile ? 14 : 18,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6B4E45),
          ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
            child: Text(
              answer,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 13 : 16,
                color: const Color(0xFF6B4E45),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
