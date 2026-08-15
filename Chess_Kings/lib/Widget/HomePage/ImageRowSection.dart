import 'package:flutter/material.dart';

class ImageRowSection extends StatelessWidget {
  const ImageRowSection({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;
    final imageSize = isMobile ? 115.0 : 300.0;
    final imageSizew = isMobile ? 115.0 : 475.0;
    final spacing = isMobile ? 2.0 : 4.0;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: spacing),
      child: Container(
        width: double.infinity,
        child: Wrap(
          spacing: spacing, // المسافة الأفقية بين الصور
          runSpacing: spacing, // المسافة الرأسية عند الالتفاف
          alignment: WrapAlignment.spaceAround,
          children: [
            Image.asset('assets/Frame2.png', width: imageSizew, height: imageSize, fit: BoxFit.fill),
            Image.asset('assets/Frame3.png', width: imageSizew, height: imageSize, fit: BoxFit.fill),
            Image.asset('assets/Frame1.png', width: imageSizew, height: imageSize, fit: BoxFit.fill),
          ],
        ),
      ),
    );
  }
}
