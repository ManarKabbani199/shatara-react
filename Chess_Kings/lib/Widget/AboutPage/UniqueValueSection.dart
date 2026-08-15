import 'package:flutter/material.dart';

class UniqueValueSection extends StatelessWidget {
  const UniqueValueSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/backAboutt.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Center(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // الصورة
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/Rectangle.png',
                  width: isMobile ? 140 : 500,
                ),
              ),

              const SizedBox(width: 20),

              // المحتوى النصي
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isMobile ? 250 : 500,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SelectableText(
                      'القيمة الفريدة',
                      style: TextStyle(
                        fontFamily: 'Alexandria',
                        fontSize: isMobile ? 35 : 40,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF6B4E45),
                      ),
                    ),
                    const SizedBox(height: 30),
                    _buildFeatureItem(
                      isMobile,
                      iconPath: 'assets/IconAbout.png',
                      title: 'أصالة بلا تعقيد',
                      description:
                      'الالتزام الكامل بالقواعد الكلاسيكية يجعل من السهل على الجميع تعلم شطارة.',
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      isMobile,
                      iconPath: 'assets/IconAbout.png',
                      title: 'إثراء استراتيجيّ',
                      description:
                      '“نظام الجيش الاحتياطي” يضاعف خيارات اللعب ويضيف عمقاً تكتيكياً لكل مباراة.',
                    ),
                    const SizedBox(height: 16),
                    _buildFeatureItem(
                      isMobile,
                      iconPath: 'assets/IconAbout.png',
                      title: 'بيئة اجتماعية',
                      description:
                      'مجتمع رقمي متكامل يوفّر مساحات للتواصل، التحدّي، وتنظيم البطولات الخاصة.',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
      bool isMobile, {
        required String iconPath,
        required String title,
        required String description,
      }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Image.asset(iconPath, width: isMobile ? 20 : 24),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SelectableText(
                title,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: isMobile ? 13 : 16,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF6B4E45),
                ),
              ),
              const SizedBox(height: 4),
              SelectableText(
                description,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: isMobile ? 11 : 13,
                  color: const Color(0xFF6B4E45),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
