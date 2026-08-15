import 'package:flutter/material.dart';

class ContactInfoBanner extends StatelessWidget {
  const ContactInfoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 600;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/baaackkkk.PNG'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/aaaab.png'),
            fit: BoxFit.cover,
          ),
        ),
        padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SelectableText(
              'قيمنا',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 27 : 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            SelectableText(
              'info@shatarachess.com',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 11 : 17,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            SelectableText(
              'www.shatarachess.com',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 11 : 17,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            SelectableText(
              'دعم مباشر عبر التطبيق وقنوات التواصل الاجتماعي',
              style: TextStyle(
                fontFamily: 'Alexandria',
                fontSize: isMobile ? 15 : 18,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
