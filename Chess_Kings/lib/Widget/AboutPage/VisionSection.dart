import 'package:flutter/material.dart';

class VisionSection extends StatelessWidget {
  const VisionSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: const Color(0xFFAB86B9),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 55),
      child: Center(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center, // تم التعديل هنا
          children: [
            // النصوص
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(height: 25,),
                    Center(
                      child: SelectableText(
                        'رؤيتنا',
                        style: TextStyle(
                          fontFamily: 'Alexandria',
                          fontSize: isMobile ? 35 : 40,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SelectableText(
                      'أن نصنع مستقبل الشطرنج العالمي من خلال تحويل الشطرنج التقليدي إلى تجربة انتماء ممتعة وتفاعلية، تمتد عبر بطولات ودوريات تجمع عشاق اللعبة في كيان واحد.',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: isMobile ? 13 : 16,
                          color: Colors.white,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(width: 20),

            // الصورة
            Expanded(
              flex: 1,
              child: Align(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/rooo.PNG',
                  width: isMobile ? 200 : 240,
                ),
              ),
            ),
          ],
        ),

      ),
      ),
    );
  }
}
