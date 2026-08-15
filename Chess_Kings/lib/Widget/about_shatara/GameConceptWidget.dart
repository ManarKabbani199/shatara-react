import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class GameConceptWidget extends StatelessWidget {
  final String title;
  final List<Widget> bulletItems;

  const GameConceptWidget({
    super.key,
    required this.title,
    required this.bulletItems,
  });

  @override
  Widget build(BuildContext context) {
    const Color textColor = Colors.black;

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0x99FFFFFF), // 60% شفافية اللون الأبيض
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // العنوان المتحول
          SelectableText(
            title,
            style: GoogleFonts.alexandria(
              fontWeight: FontWeight.bold,
              fontSize: 25,
              color: textColor,
            ),
          ),
          const SizedBox(height: 16),

          // عناصر التعداد المتغيرة
          ...bulletItems.map(
                (item) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: item),
                  const SelectableText(
                    '• ',
                    style: TextStyle(
                      fontSize: 20,
                      height: 1.6,
                      color: textColor,
                    ),
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
