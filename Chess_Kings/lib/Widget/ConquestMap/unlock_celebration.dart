import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:Chess_Cleverness/core/map_assets.dart';

/// Celebration bottom sheet shown after capturing territory on the
/// conquest map: newly unlocked lands, defeated bosses, and completed regions.
class UnlockCelebrationSheet extends StatelessWidget {
  /// Names (Arabic) of newly unlocked territories.
  final List<String> unlockedNames;

  /// Boss territories defeated in this update (display names).
  final List<String> defeatedBossNames;

  /// Region keys that became fully completed in this update.
  final List<String> completedRegions;

  /// True when the whole campaign (all territories) is now complete.
  final bool isFinalVictory;

  /// Total coins / XP owned by the player (shown in final victory).
  final int totalCoins;
  final int totalXp;

  const UnlockCelebrationSheet({
    super.key,
    this.unlockedNames = const [],
    this.defeatedBossNames = const [],
    this.completedRegions = const [],
    this.isFinalVictory = false,
    this.totalCoins = 0,
    this.totalXp = 0,
  });

  /// Shows the celebration sheet. Does nothing when there is nothing
  /// to celebrate.
  static void show(
    BuildContext context, {
    List<String> unlockedNames = const [],
    List<String> defeatedBossNames = const [],
    List<String> completedRegions = const [],
    bool isFinalVictory = false,
    int totalCoins = 0,
    int totalXp = 0,
  }) {
    if (!isFinalVictory &&
        unlockedNames.isEmpty &&
        defeatedBossNames.isEmpty &&
        completedRegions.isEmpty) {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => UnlockCelebrationSheet(
        unlockedNames: unlockedNames,
        defeatedBossNames: defeatedBossNames,
        completedRegions: completedRegions,
        isFinalVictory: isFinalVictory,
        totalCoins: totalCoins,
        totalXp: totalXp,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: const Color(0xFF161222).withValues(alpha: 0.98),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: const Border(
            top: BorderSide(color: Color(0x80D4AF37), width: 1.5),
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFD4AF37).withValues(alpha: 0.25),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
        child: Stack(
          children: [
            // Gold/purple confetti burst over the sheet.
            const Positioned.fill(
              child: IgnorePointer(child: _ConfettiBurst()),
            ),
            SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                isFinalVictory ? '🏆' : '🎉',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 56),
              ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),
              const SizedBox(height: 16),
              Text(
                isFinalVictory ? 'اكتمل الفتح!' : 'فتح جديد!',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              if (isFinalVictory) ...[
                const SizedBox(height: 8),
                const Text(
                  'لقد وحّدت المملكة تحت رايتك وهزمت ملك الظلام',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _CelebrationRow(
                        icon: '💰',
                        title: 'إجمالي العملات',
                        value: '$totalCoins',
                        color: const Color(0xFFD4AF37),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _CelebrationRow(
                        icon: '⭐',
                        title: 'إجمالي الخبرة',
                        value: '$totalXp',
                        color: const Color(0xFFAB86B9),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              ...defeatedBossNames.map(
                (name) => _CelebrationRow(
                  icon: '👑',
                  title: 'تم هزيمة الزعيم',
                  value: name,
                  color: const Color(0xFFAB86B9),
                ),
              ),
              ...completedRegions.map(
                (region) => _CelebrationRow(
                  icon: '🏆',
                  title: 'اكتمل فتح المنطقة',
                  value: kRegionNames[region] ?? region,
                  color: kRegionColors[region] ?? const Color(0xFFD4AF37),
                ),
              ),
              if (unlockedNames.isNotEmpty)
                _CelebrationRow(
                  icon: '🗺',
                  title: unlockedNames.length == 1
                      ? 'أرض جديدة مفتوحة'
                      : 'أراضٍ جديدة مفتوحة',
                  value: unlockedNames.join('، '),
                  color: const Color(0xFFD4AF37),
                ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD4AF37),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 8,
                  shadowColor: const Color(0xFFD4AF37).withValues(alpha: 0.5),
                ),
                child: Text(
                  isFinalVictory ? 'النصر الكامل 👑' : 'متابعة الفتح',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
          ],
        ),
      ),
    );
  }
}

class _CelebrationRow extends StatelessWidget {
  final String icon;
  final String title;
  final String value;
  final Color color;

  const _CelebrationRow({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: color,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.2, end: 0);
  }
}

/// One-shot confetti burst shown when the celebration sheet opens.
class _ConfettiBurst extends StatefulWidget {
  const _ConfettiBurst();

  @override
  State<_ConfettiBurst> createState() => _ConfettiBurstState();
}

class _ConfettiBurstState extends State<_ConfettiBurst>
    with SingleTickerProviderStateMixin {
  static const _colors = [
    Color(0xFFD4AF37),
    Color(0xFFAB86B9),
    Color(0xFF4CAF50),
    Colors.white,
  ];

  late final AnimationController _controller;
  late final List<_Confetto> _confetti;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..forward();
    final random = math.Random();
    _confetti = List.generate(50, (_) => _Confetto.random(random, _colors));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) => CustomPaint(
        painter: _ConfettiPainter(_confetti, _controller.value),
      ),
    );
  }
}

class _Confetto {
  final double x;
  final double angle;
  final double speed;
  final double size;
  final double spin;
  final Color color;

  _Confetto.random(math.Random random, List<Color> colors)
      : x = random.nextDouble(),
        angle = -math.pi / 2 + (random.nextDouble() - 0.5) * 1.4,
        speed = 0.35 + random.nextDouble() * 0.45,
        size = 3 + random.nextDouble() * 5,
        spin = random.nextDouble() * math.pi,
        color = colors[random.nextInt(colors.length)];
}

class _ConfettiPainter extends CustomPainter {
  final List<_Confetto> confetti;
  final double t;

  _ConfettiPainter(this.confetti, this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final c in confetti) {
      final dx = c.x * size.width +
          math.cos(c.angle) * c.speed * size.width * t * 0.4;
      final dy = size.height * 0.1 +
          math.sin(c.angle) * c.speed * size.height * t +
          0.9 * size.height * t * t;
      final opacity = (1 - t).clamp(0.0, 1.0);
      paint.color = c.color.withValues(alpha: opacity);
      canvas.save();
      canvas.translate(dx, dy);
      canvas.rotate(c.spin + t * 6);
      canvas.drawRect(
        Rect.fromCenter(center: Offset.zero, width: c.size, height: c.size * 0.6),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _ConfettiPainter oldDelegate) {
    return oldDelegate.t != t;
  }
}
