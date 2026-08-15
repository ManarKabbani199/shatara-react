import 'package:flutter/material.dart';

class ValuesSectionWidget extends StatelessWidget {
  const ValuesSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/aboutttn.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SelectableText(
              'قيمنا',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 35 : 40,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4E45),
              ),
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildValueItem(
                  context,
                  image: 'assets/regg.png',
                  title: 'الأصالة',
                  isMobile: isMobile,
                ),
                _buildValueItem(
                  context,
                  image: 'assets/regg.png',
                  title: 'المجتمع التفاعلي',
                  isMobile: isMobile,
                ),
                _buildValueItem(
                  context,
                  image: 'assets/regg.png',
                  title: 'الإبتكار المحسوب',
                  isMobile: isMobile,
                ),
              ],
            ),
            const SizedBox(height: 32),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _buildValueItem(
                  context,
                  image: 'assets/regg.png',
                  title: 'التواصل الذكي',
                  isMobile: isMobile,
                ),
                _buildValueItem(
                  context,
                  image: 'assets/regg.png',
                  title: 'التطوّر المستمر',
                  isMobile: isMobile,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueItem(
      BuildContext context, {
        required String image,
        required String title,
        String? subtitle,
        required bool isMobile,
      }) {
    return SizedBox(
      width: isMobile ? 120 : 160,
      child: Column(
        children: [
          Image.asset(image, width: isMobile ? 75 : 150),
          const SizedBox(height: 8),
          SelectableText(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: isMobile ? 15 : 21,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6B4E45),
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: 4),
            SelectableText(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 8 : 10,
                color: const Color(0xFF6B4E45),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
