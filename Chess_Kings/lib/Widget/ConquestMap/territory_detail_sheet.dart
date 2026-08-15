import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:Chess_Cleverness/core/map_assets.dart';
import 'package:Chess_Cleverness/data/territory_lore.dart';
import 'package:Chess_Cleverness/models/territory_model.dart';

/// Cinematic bottom sheet that shows territory details and lets the player start the battle.
class TerritoryDetailSheet extends StatelessWidget {
  final TerritoryModel territory;
  final bool alreadyCompleted;
  final VoidCallback onStartBattle;

  /// Called when the player wants to replay an already-captured territory.
  /// Replays grant no additional rewards.
  final VoidCallback? onReplayBattle;

  /// Opens the conquest shop (the sheet is closed first).
  final VoidCallback? onOpenShop;

  const TerritoryDetailSheet({
    super.key,
    required this.territory,
    required this.alreadyCompleted,
    required this.onStartBattle,
    this.onReplayBattle,
    this.onOpenShop,
  });

  Color _difficultyColor(String difficulty) {
    switch (difficulty.trim()) {
      case 'مبتدئ':
        return const Color(0xFF4CAF50);
      case 'متوسط':
        return const Color(0xFFFF9800);
      case 'متقدم':
        return const Color(0xFFF44336);
      default:
        return const Color(0xFF9E9E9E);
    }
  }

  String _iconForState() {
    if (alreadyCompleted) return '✅';
    if (territory.isBoss) return '👑';
    if (territory.isStarting) return '🏰';
    return '⚔';
  }

  @override
  Widget build(BuildContext context) {
    final title = territory.defender.title?['ar'] ??
        territory.defender.title?['en'] ??
        'المدافع';
    final name = territory.name['ar'] ?? territory.name['en'] ?? territory.id;
    final difficulty = territory.defender.difficulty;
    final regionColor = kRegionColors[territory.region] ?? const Color(0xFFAB86B9);
    final regionName = kRegionNames[territory.region] ?? territory.region;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        decoration: BoxDecoration(
          color: const Color(0xFF161222).withValues(alpha: 0.98),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: Border(
            top: BorderSide(
              color: regionColor.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: regionColor.withValues(alpha: 0.25),
              blurRadius: 40,
              spreadRadius: 4,
            ),
          ],
        ),
        child: SafeArea(
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
              // Region tag
              Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: regionColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: regionColor.withValues(alpha: 0.4),
                    ),
                  ),
                  child: Text(
                    regionName,
                    style: TextStyle(
                      color: regionColor,
                      fontSize: 13,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Boss badge
              if (territory.isBoss) ...[
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.6),
                      ),
                    ),
                    child: Text(
                      '👑 زعيم منطقة $regionName',
                      style: const TextStyle(
                        color: Color(0xFFD4AF37),
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
              // Hero icon
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: RadialGradient(
                      colors: [
                        regionColor,
                        regionColor.withValues(alpha: 0.3),
                      ],
                    ),
                    border: Border.all(color: Colors.white54, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: regionColor.withValues(alpha: 0.5),
                        blurRadius: 24,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      _iconForState(),
                      style: const TextStyle(fontSize: 36),
                    ),
                  ),
                ),
              )
                  .animate()
                  .scale(duration: 400.ms, curve: Curves.elasticOut),
              const SizedBox(height: 20),
              Text(
                name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
              // Lore flavor text.
              if (TerritoryLore.byId[territory.id]?['ar'] != null) ...[
                const SizedBox(height: 14),
                Text(
                  TerritoryLore.byId[territory.id]!['ar']!,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: regionColor.withValues(alpha: 0.85),
                    fontSize: 14,
                    fontStyle: FontStyle.italic,
                    height: 1.5,
                  ),
                ),
              ],
              const SizedBox(height: 28),
              // Difficulty + rewards
              Row(
                children: [
                  Expanded(
                    child: _RewardCard(
                      icon: '💰',
                      value: '+${territory.rewards.coins}',
                      label: 'عملات',
                      color: const Color(0xFFD4AF37),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _RewardCard(
                      icon: '⭐',
                      value: '+${territory.rewards.xp}',
                      label: 'خبرة',
                      color: const Color(0xFFAB86B9),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'الصعوبة',
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 16,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _difficultyColor(difficulty).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      difficulty,
                      style: TextStyle(
                        color: _difficultyColor(difficulty),
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              if (alreadyCompleted) ...[
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: const Color(0xFF4CAF50).withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Text(
                      '✓ مكتملة — إعادة اللعب بدون مكافآت',
                      style: TextStyle(
                        color: Color(0xFF4CAF50),
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: onReplayBattle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white.withValues(alpha: 0.08),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: BorderSide(
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    '🔄 إعادة اللعب',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ] else
                ElevatedButton(
                  onPressed: onStartBattle,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD4AF37),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 8,
                    shadowColor: const Color(0xFFD4AF37).withValues(alpha: 0.5),
                  ),
                  child: const Text(
                    '⚔️ بدء المعركة',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              if (onOpenShop != null) ...[
                const SizedBox(height: 10),
                TextButton.icon(
                  onPressed: onOpenShop,
                  icon: const Text('🛒'),
                  label: const Text(
                    'المتجر — قوى مساعدة ومعززات',
                    style: TextStyle(
                      color: Color(0xFFD4AF37),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _RewardCard extends StatelessWidget {
  final String icon;
  final String value;
  final String label;
  final Color color;

  const _RewardCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
