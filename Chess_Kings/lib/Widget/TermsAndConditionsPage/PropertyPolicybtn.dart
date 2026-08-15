                                                 import 'package:flutter/material.dart';

import '../../screens/PropertyPolicyPage.dart';
import '../../screens/TermsAndConditionsPage.dart';
import '../../screens/about_shatara.dart' show about_Chess;
import '../../screens/about_Chess.dart';

class PropertyPolicybtn extends StatelessWidget {
  const PropertyPolicybtn({super.key}); // ✅ يُفضل إضافة مفتاح

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // الصورة الثانية
          MouseRegion(
            cursor: SystemMouseCursors.click, // تغيير المؤشر إلى شكل يد
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PropertyPolicyPage()),
                );
              },
              child: Image.asset(
                'assets/atnp.png',
                width: isMobile ? 100 : 250,
              ),
            ),
          ),
          const SizedBox(width: 20), // مسافة بين الصورتين
          // الصورة الأولى
          MouseRegion(
            cursor: SystemMouseCursors.click, // تغيير المؤشر إلى شكل يد
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TermsAndConditionsPage()),
                );
              },
              child: Image.asset(
                'assets/atna.png',
                width: isMobile ? 100 : 250,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
