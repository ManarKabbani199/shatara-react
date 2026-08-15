import 'package:flutter/material.dart';
import '../../screens/GamePLay/ChessBoard.dart';

class CustomSectionWidget extends StatelessWidget {
  final ImageProvider imageProvider; // 👈 متحوّل للصورة (أصل/شبكة/ملف)
  const CustomSectionWidget({
    super.key,
    required this.imageProvider,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/baccckN.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // 👇 الصورة الآن تأتي من المتحوّل
              Image(
                image: imageProvider,
                height: 325,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 30),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => ChessBoard()),
              );
            },
            child: FractionallySizedBox(
              widthFactor: 0.9, // 👈 يعني 80% من عرض الشاشة
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center, // يوسّط المحتوى داخل الزر
                  children: [
                    const Text(
                      " تحدي أصدقائك",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFFAB86B9),
                        fontFamily: 'Alexandria',
                      ),
                    ),
                    const SizedBox(width: 10),
                    Image.asset(
                      "assets/IconButton.png",
                      height: 24,
                      width: 24,
                    ),
                  ],
                ),
              ),
            ),
          ),

            ],
          ),
        ),
      ),
    );
  }
}
