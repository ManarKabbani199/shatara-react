import 'package:flutter/material.dart';

class DetailedComparisonTable extends StatelessWidget {
  const DetailedComparisonTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality( // RTL
      textDirection: TextDirection.rtl,
      child: const _ComparisonBody(),
    );
  }
}

/// ألوان قريبة من التصميم في الصورة
class _AppColors {
  static const Color brandGold   = Color(0xFFF0CF53);
  static const Color headerGray  = Color(0xFFD9D3CC);
  static const Color badgePurple = Color(0xFF8E6FB1);
  static const Color textDark    = Color(0xFF6B4E45);
  static const Color cellBorder  = Color(0xFFE8E2DB);
  static const Color rowAlt      = Color(0xFFFAF8F5);
  static const Color hiYellow    = Color(0xFFF7E28E); // تمييز خلايا شطارة
}

enum Better { modern, classic, tie }

class CompareRow {
  final String feature;
  final String classic;
  final String modern;
  final Better better;
  final bool highlightModern;
  final bool highlightClassic;

  const CompareRow({
    required this.feature,
    required this.classic,
    required this.modern,
    required this.better,
    this.highlightModern = false,
    this.highlightClassic = false,
  });
}

class _ComparisonBody extends StatelessWidget {
  const _ComparisonBody();

  List<CompareRow> get rows => const [
    CompareRow(
      modern: '8×8 + مناطق دعم (3×4 لكل جانب)',
      classic: '8×8 (64 مربع)',
      feature: 'حجم الرقعة',
      better: Better.modern,
      highlightModern: true,
    ),
    CompareRow(
      modern: '56 قطعة (28 لكل لاعب)',
      classic: '32 قطعة (16 لكل لاعب)',
      feature: 'عدد القطع',
      better: Better.modern,
      highlightModern: true,
    ),
    CompareRow(
      modern: '24 قطعة إضافية (12 لكل لاعب)',
      classic: 'لا يوجد',
      feature: 'قطع الإحتياط',
      better: Better.modern,
      highlightModern: true,
    ),
    CompareRow(
      modern: 'الترقية متدرجة عبر 5 مراحل وتُحسب كل مرحلة كلفة',
      classic: 'لا يُرقّى الجندي إلا عند الصفّ الأخير بعد عدة نقلات',
      feature: 'طريقة الترقية',
      better: Better.modern,
      highlightModern: true,
    ),
    CompareRow(
      modern: 'إدخال قطع من الإحتياط',
      classic: 'غير متاح',
      feature: 'التعزيز',
      better: Better.modern,
      highlightModern: true,
    ),
    CompareRow(
      modern: 'أطول وأكثر تشويقًا بفضل التعزيز والإحتياط',
      classic: 'الوقت متوسط ومحدود الخيارات',
      feature: 'مدة اللعبة',
      better: Better.modern,
      highlightModern: true,
    ),
    CompareRow(
      modern: 'عالية جدًا بفضل التعزيز',
      classic: 'محدودة بعد فقدان قطع مهمة',
      feature: 'فرص العودة',
      better: Better.modern,
      highlightModern: true,
    ),
    CompareRow(
      modern: 'أعلى بكثير',
      classic: 'عالي',
      feature: 'التعقيد الاستراتيجي',
      better: Better.modern,
      highlightModern: true,
    ),
    CompareRow(
      modern: 'يتطلب إتقان الشطرنج أولًا',
      classic: 'صعب للمبتدئين',
      feature: 'سهولة التعلّم',
      better: Better.classic,
      highlightClassic: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isMobile = width < 700;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // شريط العنوان الذهبي
        Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          color: _AppColors.brandGold,
          alignment: Alignment.center,
          child: Text(
            'جدول المقارنة التفصيلي',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              color: _AppColors.textDark,
              fontSize: isMobile ? 18 : 22,
            ),
          ),
        ),

        if (isMobile)
        // 📱 عرض بطاقات مكدسة للجوال (بدون تمرير أفقي)
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                for (int i = 0; i < rows.length; i++)
                  _MobileRowCard(
                    row: rows[i],
                    altColor: i.isOdd ? _AppColors.rowAlt : null,
                  ),
              ],
            ),
          )
        else
        // 💻 الجدول العادي للشاشات الواسعة (مع تمرير أفقي عند الحاجة)
          LayoutBuilder(
            builder: (context, constraints) {
              final screenW = MediaQuery.of(context).size.width;
              final viewportW =
              constraints.maxWidth.isFinite ? constraints.maxWidth : screenW;
              final double minTableWidth = 860; // تضمن راحة القراءة
              final double width = viewportW < minTableWidth ? minTableWidth : viewportW;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: width,
                  child: _buildDesktopTable(context),
                ),
              );
            },
          ),
      ],
    );
  }

  // نسخة سطح المكتب / التابلت العريض
  Widget _buildDesktopTable(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: _AppColors.cellBorder),
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      margin: const EdgeInsets.all(12),
      child: Column(
        children: [
          _TableHeader(),
          const Divider(height: 0, color: _AppColors.cellBorder),
          ...List.generate(rows.length, (i) {
            final r = rows[i];
            final alt = i.isEven ? null : _AppColors.rowAlt;
            return Container(
              color: alt,
              child: _TableRow(
                feature: r.feature,
                classic: r.classic,
                modern: r.modern,
                better: r.better,
                highlightModern: r.highlightModern,
                highlightClassic: r.highlightClassic,
                isLast: i == rows.length - 1,
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// ====== مكوّن بطاقة الجوال ======
class _MobileRowCard extends StatelessWidget {
  final CompareRow row;
  final Color? altColor;

  const _MobileRowCard({required this.row, this.altColor});

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.labelLarge!.copyWith(
      color: _AppColors.textDark,
      fontWeight: FontWeight.w700,
    );
    final valueStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: _AppColors.textDark,
      height: 1.35,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: altColor ?? Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _AppColors.cellBorder),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            // الصف العلوي: الخاصية + الأفضل
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(row.feature, style: labelStyle),
                  ),
                ),
                const SizedBox(width: 8),
                _BestBadge(better: row.better),
              ],
            ),
            const SizedBox(height: 10),

            // الشطرنج التقليدي
            _MobileLabeledValue(
              label: 'الشطرنج التقليدي',
              child: _HighlightBox(
                enabled: row.highlightClassic,
                child: Text(row.classic, style: valueStyle),
              ),
            ),
            const SizedBox(height: 6),

            // شطارة المطوّرة
            _MobileLabeledValue(
              label: 'شطارة المطوّرة',
              child: _HighlightBox(
                enabled: row.highlightModern,
                child: Text(row.modern, style: valueStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MobileLabeledValue extends StatelessWidget {
  final String label;
  final Widget child;
  const _MobileLabeledValue({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodySmall!.copyWith(
      color: _AppColors.textDark,
      fontWeight: FontWeight.w700,
    );
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: labelStyle),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: _AppColors.cellBorder),
            borderRadius: BorderRadius.circular(6),
          ),
          child: child,
        ),
      ],
    );
  }
}

/// ====== رأس الجدول لسطح المكتب ======
class _TableHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final baseStyle = Theme.of(context).textTheme.titleMedium!.copyWith(
      color: _AppColors.textDark,
      fontWeight: FontWeight.w700,
    );

    return Container(
      decoration: const BoxDecoration(
        color: _AppColors.headerGray,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
      ),
      child: Row(
        children: [
          // من اليمين لليسار:
          _cell('الخاصية', baseStyle, flex: 20, align: Alignment.centerRight),
          _cell('الشطرنج التقليدي', baseStyle, flex: 34),
          _cell('شطارة المطوّرة', baseStyle, flex: 34),
          _cell('الأفضل', baseStyle, flex: 12, align: Alignment.center),
        ],
      ),
    );
  }
}

/// ====== صف الجدول لسطح المكتب ======
class _TableRow extends StatelessWidget {
  final String feature, classic, modern;
  final Better better;
  final bool highlightModern, highlightClassic;
  final bool isLast;

  const _TableRow({
    required this.feature,
    required this.classic,
    required this.modern,
    required this.better,
    required this.highlightModern,
    required this.highlightClassic,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(
      color: _AppColors.textDark,
      height: 1.4,
    );

    return Column(
      children: [
        Row(
          children: [
            // الخاصية
            Expanded(
              flex: 20,
              child: _paddedCell(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    feature,
                    style: textStyle.copyWith(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ),

            // الشطرنج التقليدي
            Expanded(
              flex: 34,
              child: _paddedCell(
                child: _HighlightBox(
                  enabled: highlightClassic,
                  child: Text(classic, style: textStyle),
                ),
              ),
            ),

            // شطارة المطوّرة
            Expanded(
              flex: 34,
              child: _paddedCell(
                child: _HighlightBox(
                  enabled: highlightModern,
                  child: Text(modern, style: textStyle),
                ),
              ),
            ),

            // الأفضل
            Expanded(
              flex: 12,
              child: Center(child: _BestBadge(better: better)),
            ),
          ],
        ),
        if (!isLast) const Divider(height: 0, color: _AppColors.cellBorder),
      ],
    );
  }

  Widget _paddedCell({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: child,
    );
  }
}

class _HighlightBox extends StatelessWidget {
  final bool enabled;
  final Widget child;

  const _HighlightBox({required this.enabled, required this.child});

  @override
  Widget build(BuildContext context) {
    if (!enabled) return child;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: _AppColors.hiYellow,
        borderRadius: BorderRadius.circular(6),
      ),
      child: child,
    );
  }
}

class _BestBadge extends StatelessWidget {
  final Better better;
  const _BestBadge({required this.better});

  @override
  Widget build(BuildContext context) {
    String label;
    switch (better) {
      case Better.modern:
        label = 'شطارة';
        break;
      case Better.classic:
        label = 'التقليدي';
        break;
      case Better.tie:
        label = 'تعادل';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: _AppColors.badgePurple,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// خلية رأس/جدول عامة
Widget _cell(
    String text,
    TextStyle style, {
      int flex = 1,
      Alignment align = Alignment.centerRight,
    }) {
  return Expanded(
    flex: flex,
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      alignment: align,
      child: Text(text, style: style),
    ),
  );
}
