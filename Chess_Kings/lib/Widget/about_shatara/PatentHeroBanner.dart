import 'package:flutter/material.dart';

class PatentHeroBanner extends StatelessWidget {
  const PatentHeroBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final w = constraints.maxWidth;
          final isMobile = w < 600;

          const purple = Color(0xFFB48BC5);

          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 12 : 24,
              vertical: isMobile ? 16 : 24,
            ),
            color: purple, // الخلفية العامة (بنفسجي)
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // مربع براءة اختراع بعرض كامل + إطار بنفسجي
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: isMobile ? 8 : 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: purple,
                      width: 2, // سمك الإطار
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '🇸🇦براءة اختراع سعودية ',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        color: purple,
                        fontSize: isMobile ? 14 : 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: isMobile ? 14 : 18),

                // العنوان
                Text(
                  'شطارة: الشطرنج كما لم تعرفه من قبل',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    color: Colors.white,
                    fontSize: isMobile ? 18 : 26,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                SizedBox(height: isMobile ? 8 : 10),

                // الوصف
                Text(
                  'اكتشف النسخة المطوّرة من الشطرنج مع قواعد جديدة ومثيرة تجعل اللعبة أكثر تشويقًا وإثارة',
                  textAlign: TextAlign.right,
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    color: Colors.white,
                    fontSize: isMobile ? 12 : 16,
                    fontWeight: FontWeight.w600,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
