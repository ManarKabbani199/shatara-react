import 'package:flutter/material.dart';

class IntroSection extends StatelessWidget {
  const IntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;
    final double fontSize = isMobile ? 25 : 35;

    return Container(
      width: double.infinity,
      color: const Color(0xFFAB86B9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 15,),
          SelectableText(
            'شطارة',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 12),
          SelectableText(
            'الشطرنج بصيغته المستقبلية: تحافظ على القواعد الكلاسيكية، وتفتح أمامك آفاقاً استراتيجية بلا حدود',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: isMobile ? 14 : 20,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 15),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/about');
            },
            child: Image.asset(
              'assets/btnAbout.png',
              width: isMobile ? 140 : 500,
            ),

          ),
          SizedBox(height: 15,),
        ],
      ),
    );
  }
}
