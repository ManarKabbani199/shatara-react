import 'package:flutter/material.dart';

class LearningSection extends StatelessWidget {
  const LearningSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/lback.png'),
          fit: BoxFit.cover,
        ),
      ),
      padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: _buildImageSection(isMobile)),
          const SizedBox(width: 24),
          Expanded(child: _buildTextSection(context, isMobile)),
        ],
      ),
    );
  }

  Widget _buildTextSection(BuildContext context, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SelectableText(
          ' شطارة ليست مجرد لعبة… إنها مستقبل الشطرنج!',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: isMobile ? 13 : 31,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF6B4E45),
          ),
        ),
        const SizedBox(height: 17),
        SelectableText(
          'هنا، تجد دروسًا ممتعة مليئة بالخدع (Tricks) التي يمكنك استخدامها في “شطارة”، إلى جانب ألغاز ذكية تدربك على التفكير وتحفّزك لتفوز على أصدقائك ومنافسيك بثقة ودهاء ',
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: isMobile ? 11 : 21,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF6B4E45),
          ),
        ),
        const SizedBox(height: 17),
        GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, '/play');
          },
          child: Image.asset(
            'assets/btn.png',
            width: isMobile ? 80 : 120,
          ),
        ),
      ],
    );
  }

  Widget _buildImageSection(bool isMobile) {
    return Image.asset(
      'assets/Main.jpg',
      width: isMobile ? 125 : 325,
      height: isMobile ? 50 : 150,
    );
  }
}
