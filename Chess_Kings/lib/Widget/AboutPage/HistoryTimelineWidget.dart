import 'package:flutter/material.dart';

class HistoryTimelineWidget extends StatelessWidget {
  const HistoryTimelineWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/backAbouto.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 20),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 75,),
            SelectableText(
              'تاريخنا  و إنجازتنا',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 15 : 21,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4E45),
              ),
            ),
            const SizedBox(height: 32),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildTimelineItem(
                    context,
                    image: 'assets/regg.png',
                    year: '2022',
                    description: 'إنطلاق الفكرة وتأسيس شركة شطارة',
                    isMobile: isMobile,
                  ),
                  _buildTimelineItem(
                    context,
                    image: 'assets/regg.png',
                    year: '2024',
                    description: 'إطلاق النموذج الأولي وحصولنا على براءة اختراع لنظام الاحتياط',
                    isMobile: isMobile,
                  ),
                  _buildTimelineItem(
                    context,
                    image: 'assets/regg.png',
                    year: 'بداية 2025',
                    description: 'إجراء أول اختبار تجريبي داخلي بمشاركة 5,000 لاعب',
                    isMobile: isMobile,
                  ),
                  _buildTimelineItem(
                    context,
                    image: 'assets/regg.png',
                    year: 'منتصف 2025',
                    description: 'تنظيم أول بطولة عبر المنصة، واستقطاب 20,000 مشترك',
                    isMobile: isMobile,
                  ),
                ],
              ),
            ),
            SizedBox(height: 35,),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(BuildContext context, {
    required String image,
    required String year,
    required String description,
    required bool isMobile,
  }) {
    return Container(
      width: isMobile ? 160 : 220,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(image, width: isMobile ? 50 : 100),
          const SizedBox(height: 8),
          SelectableText(
            year,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 10 : 19,
            ),
          ),
          const SizedBox(height: 4),
          Container(
            width: isMobile ? 50 : 150,
            height: 2,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 8),
          SelectableText(
            description,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: isMobile ? 8 : 17,
              color: const Color(0xFF6B4E45),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
