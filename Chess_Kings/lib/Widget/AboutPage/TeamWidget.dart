import 'package:flutter/material.dart';

class TeamWidget extends StatelessWidget {
  const TeamWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/aboutttn.png'),
          fit: BoxFit.cover,
        ),
      ),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10,),
            SelectableText(
              'فريقنا',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 35 : 40,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF6B4E45),
              ),
            ),
            const SizedBox(height: 32),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildTeamMember(
                    context,
                    image: 'assets/ahma.png',
                    name: 'احمد بن سفير',
                    role:  'Inventor / Chairman\nالمبتكر ورئيس مجلس الإدارة',
                    isMobile: isMobile,
                  ),
                  _buildTeamMember(
                    context,
                    image: 'assets/ahmh.png',
                    name: 'أحمد الحرة',
                    role: 'CEO الرئيس التنفيذي',
                    isMobile: isMobile,
                  ),
                  _buildTeamMember(
                    context,
                    image: 'assets/abd.png',
                    name: 'عبد الله الشمراني',
                    role: 'المدير المالي CFO',
                    isMobile: isMobile,
                  ),
                  _buildTeamMember(
                    context,
                    image: 'assets/engm.png',
                    name: 'منار قباني',
                    role: 'المديرة التقنية CTO',
                    isMobile: isMobile,
                  ),
                  _buildTeamMember(
                    context,
                    image: 'assets/osa.png',
                    name: 'أسامه عسكر',
                    role: 'مدير المبيعات و العلاقات CRMO',
                    isMobile: isMobile,
                  ),
                  _buildTeamMember(
                    context,
                    image: 'assets/ebth.png',
                    name: 'ابتهال العزاز',
                    role: 'مدير التسويقCMO',
                    isMobile: isMobile,
                  ),





                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMember(BuildContext context, {
    required String image,
    required String name,
    required String role,
    required bool isMobile,
  }) {
    return Container(
      width: isMobile ? 160 : 200,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Image.asset(image, width: isMobile ? 60 : 120),
          const SizedBox(height: 8),
          SelectableText(
            name,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontWeight: FontWeight.bold,
              fontSize: isMobile ? 11 : 15,
              color: const Color(0xFF6B4E45),
            ),
          ),
          const SizedBox(height: 4),
          SelectableText(
            role,
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: isMobile ? 8 : 10,
              color: const Color(0xFF6B4E45),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
