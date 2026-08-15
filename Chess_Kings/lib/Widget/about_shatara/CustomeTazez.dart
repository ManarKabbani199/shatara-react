import 'package:flutter/material.dart';

class CustomeTazez extends StatelessWidget {
  const CustomeTazez({super.key});

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0x99FFFFFF), // خلفية شفافة
          borderRadius: BorderRadius.circular(12),
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان
              SelectableText(
                'شرح التعزيز',
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.bold,
                  fontSize: isMobile ? 19 : 25,
                  color: const Color(0xFF6B4E45),
                ),
              ),
              const SizedBox(height: 12),

              // صف الصور
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildImage('assets/t1.png'),
                  _buildImage('assets/t2.png'),
                  _buildImage('assets/t3.png'),
                  _buildImage('assets/t4.png'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: AspectRatio(
          aspectRatio: 1, // مربع تقريبي
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.asset(
              path,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }

}
