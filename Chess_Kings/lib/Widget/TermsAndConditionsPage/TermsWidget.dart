import 'package:flutter/material.dart';

/// Widget عام (RTL) بمحتوى متحوّل بالكامل
/// - الخلفية العامة: #E5E7EB
/// - محاذاة النص يمين، واتجاه RTL
/// - القسم الأول: أيقونة (متحول) + عنوان (Bold) + سطر نص (متحول)
/// - القسم الثاني: خلفية #F9FAFB + نص (متحول)
/// - الألوان للنص: #6B4E45
/// - الخط: Alexandria (تأكد من إضافته في pubspec.yaml)
/// - الأحجام: عنوان 21 (موبايل 17)، نص 14 (موبايل 11)
class TermsWidget extends StatelessWidget {
  const TermsWidget({
    super.key,
    required this.iconImage,
    required this.titleText,
    required this.firstLineText,
    required this.secondSectionText,
    this.mobileBreakpoint = 600,
    this.iconSize = 28,
  });

  /// مصدر الأيقونة متحوّل (AssetImage/NetworkImage/MemoryImage ...)
  final ImageProvider<Object> iconImage;

  /// نص عنوان القسم الأول (Bold)
  final String titleText;

  /// النص أسفل العنوان في القسم الأول
  final String firstLineText;

  /// نص القسم الثاني داخل صندوق بخلفية #F9FAFB
  final String secondSectionText;

  /// نقطة التحوّل بين الموبايل وغيره
  final double mobileBreakpoint;

  /// حجم الأيقونة
  final double iconSize;

  double _responsiveFont(BuildContext context, double desktop, double mobile) {
    final w = MediaQuery.of(context).size.width;
    return w < mobileBreakpoint ? mobile : desktop;
  }

  static const _bgAll = Color(0xFFE5E7EB);
  static const _bgSection2 = Color(0xFFF9FAFB);
  static const _textColor = Color(0xFF6B4E45);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        color: _bgAll,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            _SectionOne(
              iconImage: iconImage,
              iconSize: iconSize,
              titleText: titleText,
              firstLineText: firstLineText,
              titleSizeDesktop: 21,
              titleSizeMobile: 17,
              bodySizeDesktop: 14,
              bodySizeMobile: 11,
              textColor: _textColor,
              responsiveFont: (d, m) => _responsiveFont(context, d, m),
            ),
            const SizedBox(height: 12),
            _SectionTwo(
              text: secondSectionText,
              bodySizeDesktop: 14,
              bodySizeMobile: 11,
              textColor: _textColor,
              responsiveFont: (d, m) => _responsiveFont(context, d, m),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionOne extends StatelessWidget {
  const _SectionOne({
    required this.iconImage,
    required this.iconSize,
    required this.titleText,
    required this.firstLineText,
    required this.titleSizeDesktop,
    required this.titleSizeMobile,
    required this.bodySizeDesktop,
    required this.bodySizeMobile,
    required this.textColor,
    required this.responsiveFont,
  });

  final ImageProvider<Object> iconImage;
  final double iconSize;
  final String titleText;
  final String firstLineText;
  final double titleSizeDesktop;
  final double titleSizeMobile;
  final double bodySizeDesktop;
  final double bodySizeMobile;
  final Color textColor;
  final double Function(double desktop, double mobile) responsiveFont;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image(
              image: iconImage,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SelectableText(
                titleText,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Alexandria',
                  fontSize: responsiveFont(titleSizeDesktop, titleSizeMobile),
                  fontWeight: FontWeight.w700, // Bold
                  color: textColor,
                  height: 1.3,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SelectableText(
          firstLineText,
          textAlign: TextAlign.right,
          style: TextStyle(
            fontFamily: 'Alexandria',
            fontSize: responsiveFont(bodySizeDesktop, bodySizeMobile),
            fontWeight: FontWeight.w400,
            color: textColor,
            height: 1.6,
          ),
        ),
      ],
    );
  }
}

class _SectionTwo extends StatelessWidget {
  const _SectionTwo({
    required this.text,
    required this.bodySizeDesktop,
    required this.bodySizeMobile,
    required this.textColor,
    required this.responsiveFont,
  });

  final String text;
  final double bodySizeDesktop;
  final double bodySizeMobile;
  final Color textColor;
  final double Function(double desktop, double mobile) responsiveFont;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.zero,
      ),
      child: SelectableText(
        text,
        textAlign: TextAlign.right,
        style: TextStyle(
          fontFamily: 'Alexandria',
          fontSize: responsiveFont(bodySizeDesktop, bodySizeMobile),
          fontWeight: FontWeight.w400,
          color: textColor,
          height: 1.6,
        ),
      ),
    );
  }
}

