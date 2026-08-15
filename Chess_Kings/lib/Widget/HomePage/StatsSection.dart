import 'package:flutter/material.dart';

class StatsSection extends StatelessWidget {
  final String soldGames;   // منتج تم بيعه
  final String onlineUsers; // متواجد الآن
  final String countries;   // بلد
  final String visitor;     // زائر

  const StatsSection({
    super.key,
    required this.soldGames,
    required this.onlineUsers,
    required this.countries,
    required this.visitor,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: LayoutBuilder(
        builder: (context, c) {
          final w = c.maxWidth;

          // ارتفاع الشريط متناسِب مع العرض (ومقيّد بحدود مريحة)
          double barH = (w < 600 ? w * 0.20 : w * 0.085).clamp(84.0, 140.0);

          // أحجام الأيقونة والخط مبنية على ارتفاع الشريط
          final double iconH   = (barH * 0.50).clamp(24.0, 56.0);
          final double iconW   = (iconH * 1.0).clamp(24.0, 56.0);
          final double gap     = (barH * 0.08).clamp(4.0, 10.0); // 🔹 تقليل المسافة
          final double valueSz = (barH * 0.34).clamp(14.0, 26.0);
          final double labelSz = (barH * 0.22).clamp(10.0, 16.0);

          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/stat.png'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
            child: SizedBox(
              height: barH,
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 🔹 توزيع متوازن
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SelectableText(
                    'أرقامنا هي التي تتحدث عنا ',
                    style: TextStyle(
                      fontFamily: 'Alexandria',
                      fontSize: 17,
                      color: const Color(0xFF000000),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  _StatItem(
                    value: visitor,
                    label: 'زائر',
                    iconPath: 'assets/ico1.png', // ✅ أيقونة الزائر
                    iconH: iconH,
                    iconW: iconW,
                    gap: gap,
                    valueSize: valueSz,
                    labelSize: labelSz,
                  ),
                  _StatItem(
                    value: onlineUsers,
                    label: 'متواجد الآن',
                    iconPath: 'assets/ico2.png', // ✅ أيقونة المتواجدين
                    iconH: iconH,
                    iconW: iconW,
                    gap: gap,
                    valueSize: valueSz,
                    labelSize: labelSz,
                  ),
                  _StatItem(
                    value: countries,
                    label: 'بلد',
                    iconPath: 'assets/ico3.png', // ✅ أيقونة الدول
                    iconH: iconH,
                    iconW: iconW,
                    gap: gap,
                    valueSize: valueSz,
                    labelSize: labelSz,
                  ),

                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.iconPath,
    required this.iconH,
    required this.iconW,
    required this.gap,
    required this.valueSize,
    required this.labelSize,
  });

  final String value;
  final String label;
  final String iconPath;
  final double iconH, iconW, gap, valueSize, labelSize;

  static const Color _textColor = Color(0xFF6B4E45);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          iconPath, // ✅ أيقونة مخصصة
          height: iconH,
          width: iconW,
          fit: BoxFit.contain,
        ),
        SizedBox(width: gap),
        Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                value,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontWeight: FontWeight.bold,
                  fontSize: valueSize,
                  color: _textColor,
                ),
              ),
            ),
            const SizedBox(height: 2),
            FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerRight,
              child: Text(
                label,
                softWrap: false,
                overflow: TextOverflow.fade,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: labelSize,
                  color: _textColor,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
