import 'package:flutter/material.dart';

class ThreeImagesRow extends StatelessWidget {
  const ThreeImagesRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        SizedBox(width: 15),
        Expanded(
          child: Image(
            image: AssetImage('assets/am1.png'),
            fit: BoxFit.cover, // يخلي الصورة تملأ المساحة
          ),
        ),
        SizedBox(width: 15), // مسافة بسيطة بين الصور
        Expanded(
          child: Image(
            image: AssetImage('assets/am2.png'),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: Image(
            image: AssetImage('assets/am3.png'),
            fit: BoxFit.cover,
          ),
        ),
        SizedBox(width: 15),
      ],
    );
  }
}
