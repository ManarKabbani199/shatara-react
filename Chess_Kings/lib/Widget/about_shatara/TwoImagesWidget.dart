import 'package:flutter/material.dart';

class TwoImagesWidget extends StatelessWidget {
  final String imagePath1;
  final String imagePath2;

  const TwoImagesWidget({
    super.key,
    required this.imagePath1,
    required this.imagePath2,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // نقسم العرض على 3 علشان نخلي الصور مناسبة (مع التباعد)
    final imageWidth = (screenWidth / 3) - 10;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          imagePath1, // ✅ أول صورة متغيّر
          width: imageWidth,
          fit: BoxFit.cover,
        ),
        const SizedBox(width: 5), // تباعد بين الصورتين
        Image.asset(
          imagePath2, // ✅ ثاني صورة متغيّر
          width: imageWidth,
          fit: BoxFit.cover,
        ),
      ],
    );
  }
}
