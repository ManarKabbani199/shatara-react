import 'package:flutter/material.dart';

class SixImagesList extends StatelessWidget {
  const SixImagesList({super.key});

  @override
  Widget build(BuildContext context) {
    const imagePaths = [
      'assets/ab1.png',
      'assets/ab2.png',
      'assets/ab3.png',
      'assets/ab4.png',
      'assets/ab5.png',
      'assets/ab6.png',
    ];

    final screenWidth = MediaQuery.of(context).size.width;
    // كل صف فيه 3 صور => نقسم العرض على 3 مع حساب التباعد
    final imageSize = (screenWidth / 5) - 10;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // الصف الأول
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 0; i < 3; i++) ...[
              Image.asset(
                imagePaths[i],
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
              if (i < 2) const SizedBox(width: 5),
            ]
          ],
        ),
        const SizedBox(height: 5),
        // الصف الثاني
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int i = 3; i < 6; i++) ...[
              Image.asset(
                imagePaths[i],
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
              ),
              if (i < 5) const SizedBox(width: 5),
            ]
          ],
        ),
      ],
    );
  }
}
