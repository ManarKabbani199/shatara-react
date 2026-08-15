import 'package:flutter/material.dart';

class GametWidget extends StatelessWidget {
  final String title;
  final String description;
  final String imagePath;

  const GametWidget({
    Key? key,
    required this.title,
    required this.description,
    required this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return  Container(
        padding: const EdgeInsets.all(16),
    margin: const EdgeInsets.all(16),
    decoration: BoxDecoration(
    color: const Color(0x99FFFFFF), // 60% شفافية اللون الأبيض
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SelectableText(
          title,
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.bold,
            fontSize: isMobile ? 19 : 25,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        SelectableText(
          description,
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.normal,
            fontSize: isMobile ? 10 : 15,
            color: Colors.black,
          ),
          textAlign: TextAlign.right,
        ),
        const SizedBox(height: 12),
        Center(child: Image.asset(imagePath)),
      ],
    ),
    );
  }
}
