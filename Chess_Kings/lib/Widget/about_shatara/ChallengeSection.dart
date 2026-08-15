import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// استخدمه داخل أي صفحة:
/// Scaffold(body: SingleChildScrollView(child: ChallengeSection()))
class ChallengeSection extends StatelessWidget {
  const ChallengeSection({super.key});

  @override
  Widget build(BuildContext context) {
    // ===== إعداد خطوط القسم السفلي =====
    const double _lineThickness = 1; // سُمك الخط
    const double _lineOpacity   = 0.9; // شفافية الخط

    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 32),
        // صورة كخلفية
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bam.png'),
            fit: BoxFit.cover,
          ),
        ),
        // تدرّج أمامي لتحسين التباين + لمسة بنفسجية تناسب الهوية

        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // العنوان
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'هل أنت مستعد للتحدي؟',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontFamily: 'Alexandria',
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // الوصف
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'ابدأ رحلتك من تعلم الشطرنج التقليدي وصولاً إلى إتقان شطارة المطوّرة',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontFamily: 'Alexandria',
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // زر CTA
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFAB86B9), // لون الخلفية
                    foregroundColor: Colors.white,            // لون النص والأيقونة
                    padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,        // حواف حادة
                    ),
                    textStyle: const TextStyle(
                      fontFamily: 'Alexandria',
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  ),
                  onPressed: () {},
                  child: const Text('جرّب شطارة الآن'),
                ),
                const SizedBox(height: 24),

                // البطاقات (Responsive)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth >= 900;
                      final crossAxisCount = isWide ? 3 : 1;
                      return GridView.count(
                        crossAxisCount: crossAxisCount,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: isWide ? 1.6 : 3.2,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        children: const [
                            _FeatureCard(
                              backgroundAsset: 'assets/saaa.PNG',
                              title: 'ابتكار سعودي',
                              subtitle: 'كن جزءًا من الابتكار السعودي في عالم الذكاء الاصطناعي',
                              borderColor: Color(0xFF7C5F8F),
                            ),
                            _FeatureCard(
                              backgroundAsset: 'assets/tth.PNG',
                              title: 'تحديات مثيرة',
                              subtitle: 'استكشف تحديات جديدة ومتنوعة لم تجربها من قبل',
                              borderColor: Color(0xFFE3C76E),
                              highlight: true,
                            ),
                            _FeatureCard(
                              backgroundAsset: 'assets/tdd.PNG',
                              title: 'تعلّم تدريجي',
                              subtitle: 'ابدأ بالتقليدي ثم انتقل إلى شطارة المطوّرة في مسار تدريجي',
                              borderColor: Color(0xFF7C5F8F),
                            ),
                        ],
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // خط أبيض فوق "تعلّم الشطرنج وشطارة"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: _lineThickness,
                    color: Colors.white.withOpacity(_lineOpacity),
                  ),
                ),
                const SizedBox(height: 10),

                // عنوان فرعي
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'تعلّم الشطرنج وشطارة',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontFamily: 'Alexandria',
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 6),

                // وصف فرعي
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'من الأساسيات إلى الاحتراف',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontFamily: 'Alexandria',
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // خط أبيض تحت "من الأساسيات إلى الاحتراف"
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: _lineThickness,
                    color: Colors.white.withOpacity(_lineOpacity),
                  ),
                ),

                const SizedBox(height: 20),
                // فوتر صغير
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '© 2024 منصة تعلم الشطرنج وشطارة. جميع الحقوق محفوظة. تصميم واجهة مشابهة وفق الرؤية السعودية.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontFamily: 'Alexandria',
                      color: Colors.white.withOpacity(0.75),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// بطاقة ميزة واحدة
class _FeatureCard extends StatefulWidget {
  final String title;
  final String subtitle;
  final Color borderColor;
  final bool highlight;
  final String? backgroundAsset; // خلفية اختيارية

  const _FeatureCard({
    required this.title,
    required this.subtitle,
    required this.borderColor,
    this.highlight = false,
    this.backgroundAsset,
  });

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool hovering = false;

  @override
  Widget build(BuildContext context) {
    final baseBorder = widget.borderColor;
    final effectiveBorder =
    hovering ? baseBorder.withOpacity(1) : baseBorder.withOpacity(0.75);

    final shadow = widget.highlight
        ? [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))]
        : [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 3))];

    final cardCore = AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: widget.backgroundAsset == null
            ? Colors.white.withOpacity(widget.highlight ? 0.08 : 0.06)
            : null,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: effectiveBorder, width: 2),
        boxShadow: shadow,
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          if (widget.backgroundAsset != null)
            Positioned.fill(
              child: Image.asset(widget.backgroundAsset!, fit: BoxFit.cover),
            ),
          if (widget.backgroundAsset != null)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter, end: Alignment.bottomCenter,
                    colors: [Colors.black.withOpacity(0.20), Colors.black.withOpacity(0.30)],
                  ),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,   // وسط عموديًا
              crossAxisAlignment: CrossAxisAlignment.center, // وسط أفقيًا
              children: [
                // لا أيقونة هنا
                Text(
                  widget.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'Alexandria',
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  widget.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Alexandria',
                    color: Colors.white.withOpacity(0.92),
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );

    return kIsWeb
        ? MouseRegion(
      onEnter: (_) => setState(() => hovering = true),
      onExit:  (_) => setState(() => hovering = false),
      cursor: SystemMouseCursors.click,
      child: cardCore,
    )
        : cardCore;
  }
}
