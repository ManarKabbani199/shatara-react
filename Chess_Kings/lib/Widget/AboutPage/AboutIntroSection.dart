import 'package:flutter/material.dart';

class AboutIntroSection extends StatelessWidget {
  const AboutIntroSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      color: const Color(0xFFAB86B9),
      child: Column(
        children: [
          SizedBox(height: 25,),
          SelectableText(
            'من نحن',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: isMobile ? 18 : 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SelectableText(
              'شركة شطارة تعيد تقديم تجربة الشطرنج بما يتناسب وروح العصر، محافظةً على المبادئ والقواعد الأصيلة دون تعقيد إضافي. لقد ارتقينا بلعبة الشطرنج التي نحبها فصارت أكثر ذكاءً وتفاعلاً ومتعةً. أضفنا “نظام الجيش الاحتياطي” ليوسع من إمكانياتك التكتيكية، ودمجنا تحليل الذكاء الاصطناعي والتحديات والالغاز لتُسهم في تطوير مستواك وفهمك لكل نقلة بعمق. والأهمّ أننا أسسنا مجتمعًا رقميًا تفاعليًا يتيح لك التواصل والتحدّي والتعلم مع لاعبين من مختلف أنحاء العالم.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 10 : 15,
                color: Colors.white,
                height: 1.6,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
