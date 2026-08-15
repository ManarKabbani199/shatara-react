import 'package:flutter/material.dart';

import '../../screens/about_shatara.dart' show about_Chess;
import '../../screens/about_Chess.dart';

class btnAboutShatra extends StatelessWidget {
  const btnAboutShatra({super.key}); // ✅ يُفضل إضافة مفتاح

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

        MouseRegion(
        cursor: SystemMouseCursors.click, // تغيير المؤشر إلى شكل يد
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => about_shatara()),
              );
            },
            child: Image.asset(
              'assets/btnShatara2.png',
              width: isMobile ? 100 : 250,
            ),
          ),
        ),
          const SizedBox(width: 20), // مسافة بين الصورتين
      MouseRegion(
        cursor: SystemMouseCursors.click, // تغيير المؤشر إلى شكل يد
        child:  GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => about_Chess()),
              );
            },
            child: Image.asset(
              'assets/btnShatara.png',
              width: isMobile ? 100 : 250,
            ),
          ),
         ),
        ],
      ),
    );
  }
}
