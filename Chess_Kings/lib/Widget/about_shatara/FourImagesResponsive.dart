import 'package:flutter/material.dart';

class FourImagesGrid extends StatelessWidget {
  final List<String> imagePaths; // 🔹 صور قابلة للتغيير

  const FourImagesGrid({
    super.key,
    required this.imagePaths, // ✅ تمرّرها من الخارج
  });

  @override
  Widget build(BuildContext context) {
    // 🔹 عرض الشاشة
    final width = MediaQuery.of(context).size.width;

    // 🔹 ضبط الحجم حسب نوع الجهاز
    final crossAxisCount = 2;
    final spacing = 14.0;
    double maxTileSize;

    if (width > 1200) {
      maxTileSize = 320; // كمبيوتر كبير
    } else if (width > 800) {
      maxTileSize = 260; // لابتوب
    } else if (width > 600) {
      maxTileSize = 200; // تابلت
    } else {
      maxTileSize = 150; // جوال
    }

    // 🔹 العرض الكلي المتاح
    final totalWidth =
        (maxTileSize * crossAxisCount) + (spacing * (crossAxisCount - 1)) + 32;

    return Center(
      child: SizedBox(
        width: totalWidth.clamp(300, width * 0.9),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: imagePaths.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: 1,
            ),
            itemBuilder: (context, i) => _ImageTileContain(path: imagePaths[i]),
          ),
        ),
      ),
    );
  }
}

class _ImageTileContain extends StatelessWidget {
  final String path;
  const _ImageTileContain({required this.path});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: Container(
        color: const Color(0xFFF5F5F5),
        padding: const EdgeInsets.all(8),
        child: Center(
          child: Image.asset(
            path,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
