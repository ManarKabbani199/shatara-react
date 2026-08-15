import 'package:flutter/material.dart';

class LimitedEditionSection extends StatelessWidget {
  const LimitedEditionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      height: isMobile ? 250 : 350, // تقليل الارتفاع العام حسب نوع الجهاز
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/backSp.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: Image.asset('assets/iconssh.png', width: isMobile ? 80 : 160)),
          const SizedBox(width: 16),
          Expanded(child: _buildTextContent(context, isMobile)),
        ],
      ),
    );
  }

  Widget _buildTextContent(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        SelectableText(
          'SHATARA CHESS - LIMITED EDITION',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: isMobile ? 16 : 32,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6B4E45),
          ),
        ),
        const SizedBox(height: 8),
        Image.asset('assets/pric.png', width: isMobile ? 90 : 160),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [


            Expanded(
              child: SelectableText(
                'رقعة خشبية مطورة عن التقليدية',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6B4E45),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Image.asset('assets/chessicon.png', width: 20),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Expanded(
              child: SelectableText(
                'بطاقة عضوية تؤهلك للدخول لكل اجتماعات شطارة الخاصة',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6B4E45),
                ),
              ),
            ),
            const SizedBox(width: 6),
            Image.asset('assets/chessicon.png', width: 20),


          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/play'),
              child: Image.asset('assets/buy1.png', width: isMobile ? 70 : 100),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: () => Navigator.pushNamed(context, '/view'),
              child: Image.asset('assets/view.png', width: isMobile ? 70 : 100),
            ),
          ],
        ),
      ],
    );
  }
}
