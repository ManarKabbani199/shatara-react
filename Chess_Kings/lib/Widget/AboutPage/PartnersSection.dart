import 'package:flutter/material.dart';

class PartnersSection extends StatelessWidget {
  const PartnersSection({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      color: const Color(0xFFAB86B9),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 9,),
          SelectableText(
            'شركاؤنا و داعمونا',
            style: TextStyle(
              fontFamily: 'Alexandria',
              fontSize: isMobile ? 20 : 25,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // القسم الأول
              Column(
                children: [
                  Image.asset(
                    'assets/GitHub_Logo.png',
                    width: isMobile ? 50 : 70,
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    'داعم مالي',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: isMobile ? 10 : 15,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),

              // الفاصل
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 30),
                width: 1,
                height: isMobile ? 40 : 60,
                color: Colors.white54,
              ),

              // القسم الثالث
              Column(
                children: [
                  Image.asset(
                    'assets/GitHub_Logo.png',
                    width: isMobile ? 50 : 70,
                  ),
                  const SizedBox(height: 8),
                  SelectableText(
                    'شريك إستراتيجي',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: isMobile ? 10 : 15,
                      color: Colors.white,
                    ),
                  ),

                ],
              ),
            ],
          ),
          SizedBox(height: 15,),
        ],
      ),
    );
  }
}
