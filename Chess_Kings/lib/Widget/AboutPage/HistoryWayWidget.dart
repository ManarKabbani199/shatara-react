import 'package:flutter/material.dart';

class HistoryWayWidget extends StatelessWidget {
  const HistoryWayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      color: const Color(0xFFAB86B9),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 45,),
            SelectableText(
              'خارطة الطريق المستقبلية',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 15 : 21,
                fontWeight: FontWeight.bold,
                color: Colors.white,
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
                    image: 'assets/reggm.png',
                    year: 'أغسطس 2025',
                    description: 'إطلاق التطبيق المحمول',
                    isMobile: isMobile,
                  ),
                  _buildTimelineItem(
                    context,
                    image: 'assets/reggm.png',
                    year: 'أكتوبر 2025',
                    description: 'إضافة التحديات اليومية',
                    isMobile: isMobile,
                  ),
                  _buildTimelineItem(
                    context,
                    image: 'assets/reggm.png',
                    year: 'ديسمبر 2025',
                    description: 'توسيع دعم اللغات و توطين المحتوى',
                    isMobile: isMobile,
                  ),
                  _buildTimelineItem(
                    context,
                    image: 'assets/reggm.png',
                    year: 'مارس 2026',
                    description: 'إطلاق أول دوري عالمي رسمي',
                    isMobile: isMobile,
                  ),
                ],
              ),
            )
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
          SelectableText(
            year,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 9 : 13,
            ),
          ),
          const SizedBox(height: 8),
          SelectableText(
            description,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: isMobile ? 6 : 12,
              color:  Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Image.asset(image, width: isMobile ? 50 : 100),
        ],
      ),
    );
  }
}
