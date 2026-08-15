import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:Chess_Cleverness/models/conquest_inventory_model.dart';
import 'package:Chess_Cleverness/models/conquest_progress_model.dart';
import 'package:Chess_Cleverness/screens/GamePLay/color.dart';
import 'package:Chess_Cleverness/services/conquest_inventory_service.dart';
import 'package:Chess_Cleverness/services/conquest_local_progress_service.dart';
import 'package:Chess_Cleverness/services/conquest_progress_service.dart';
import 'package:Chess_Cleverness/services/map_sound_service.dart';
import 'package:Chess_Cleverness/services/purchase_service.dart';

/// Shop item costs (coins).
class ShopPrices {
  ShopPrices._();

  static const hint = 50;
  static const extraTime = 40;
  static const undo = 60;
  static const xpBoost = 150;
  static const coinBoost = 150;
  static const theme = 200;
}

/// Board themes sold in the shop (keys must exist in BoardThemes.themes).
const Map<String, String> kShopThemeNames = {
  'brown': 'بني كلاسيكي',
  'blackWhite': 'أبيض وأسود',
  'blueWhite': 'أزرق ملكي',
};

/// Conquest shop bottom sheet: power-ups, boosters, board themes, and
/// real-money coin packs. Works for guests (local storage) and logged-in
/// players (Firestore).
class ConquestShopSheet extends StatefulWidget {
  const ConquestShopSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ConquestShopSheet(),
    );
  }

  @override
  State<ConquestShopSheet> createState() => _ConquestShopSheetState();
}

class _ConquestShopSheetState extends State<ConquestShopSheet> {
  String? get _uid => FirebaseAuth.instance.currentUser?.uid;

  ConquestInventoryModel _inventory = const ConquestInventoryModel();
  int _coins = 0;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final inventory = await ConquestInventoryService.getInventory(_uid);
      final ConquestProgressModel progress = _uid == null
          ? await ConquestLocalProgressService.getProgress()
          : await ConquestProgressService.getProgress(_uid!);
      if (!mounted) return;
      setState(() {
        _inventory = inventory;
        _coins = progress.coins;
        _loading = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _toast(String message, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, textAlign: TextAlign.center),
        backgroundColor: error ? const Color(0xFFB3382E) : null,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _buy(
    int cost,
    ConquestInventoryModel Function(ConquestInventoryModel) apply,
    String successMessage,
  ) async {
    final ok = await ConquestInventoryService.tryPurchase(_uid, cost, apply);
    if (!mounted) return;
    if (ok) {
      MapSoundService.play(MapSfx.shop);
      _toast(successMessage);
      await _load();
    } else {
      MapSoundService.play(MapSfx.locked);
      _toast('عملات غير كافية! اكسب المزيد من المعارك', error: true);
    }
  }

  Future<void> _selectTheme(String key) async {
    await ConquestInventoryService.saveInventory(
      _uid,
      _inventory.copyWith(selectedTheme: key),
    );
    MapSoundService.play(MapSfx.click);
    await _load();
  }

  Future<void> _buyPack(CoinPack pack) async {
    final message = await PurchaseService.buyPack(pack, _uid);
    if (message != null && mounted) _toast(message);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF161222).withValues(alpha: 0.98),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
          border: const Border(
            top: BorderSide(color: Color(0x80D4AF37), width: 1.5),
          ),
        ),
        child: SafeArea(
          child: _loading
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(40),
                    child: CircularProgressIndicator(
                      color: Color(0xFFD4AF37),
                    ),
                  ),
                )
              : SingleChildScrollView(
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
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            '🛒 متجر الفتح',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFD4AF37)
                                  .withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: const Color(0xFFD4AF37)
                                    .withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              '💰 $_coins',
                              style: const TextStyle(
                                color: Color(0xFFD4AF37),
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // ── Power-ups ─────────────────────────────
                      const _SectionTitle('⚡ قوى مساعدة'),
                      Row(
                        children: [
                          Expanded(
                            child: _ShopItemCard(
                              icon: '💡',
                              name: 'تلميح',
                              description: 'يكشف أفضل حركة',
                              price: ShopPrices.hint,
                              owned: _inventory.hints,
                              onBuy: () => _buy(
                                ShopPrices.hint,
                                (i) => i.copyWith(hints: i.hints + 1),
                                '💡 اشتريت تلميحاً!',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ShopItemCard(
                              icon: '⏱',
                              name: 'وقت إضافي',
                              description: '+120 ثانية',
                              price: ShopPrices.extraTime,
                              owned: _inventory.extraTime,
                              onBuy: () => _buy(
                                ShopPrices.extraTime,
                                (i) =>
                                    i.copyWith(extraTime: i.extraTime + 1),
                                '⏱ اشتريت وقتاً إضافياً!',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ShopItemCard(
                              icon: '↩',
                              name: 'تراجع',
                              description: 'استرجع حركتك',
                              price: ShopPrices.undo,
                              owned: _inventory.undos,
                              onBuy: () => _buy(
                                ShopPrices.undo,
                                (i) => i.copyWith(undos: i.undos + 1),
                                '↩ اشتريت تراجعاً!',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Boosters ──────────────────────────────
                      const _SectionTitle('🚀 معززات'),
                      Row(
                        children: [
                          Expanded(
                            child: _ShopItemCard(
                              icon: '⭐',
                              name: 'خبرة مضاعفة',
                              description: '2x لثلاث معارك',
                              price: ShopPrices.xpBoost,
                              owned: _inventory.xpBoostBattles,
                              ownedLabel: 'معركة متبقية',
                              onBuy: () => _buy(
                                ShopPrices.xpBoost,
                                (i) => i.copyWith(
                                    xpBoostBattles: i.xpBoostBattles + 3),
                                '⭐ فعّلت الخبرة المضاعفة!',
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _ShopItemCard(
                              icon: '💰',
                              name: 'عملات مضاعفة',
                              description: '2x لثلاث معارك',
                              price: ShopPrices.coinBoost,
                              owned: _inventory.coinBoostBattles,
                              ownedLabel: 'معركة متبقية',
                              onBuy: () => _buy(
                                ShopPrices.coinBoost,
                                (i) => i.copyWith(
                                    coinBoostBattles:
                                        i.coinBoostBattles + 3),
                                '💰 فعّلت العملات المضاعفة!',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Board themes ──────────────────────────
                      const _SectionTitle('🎨 مظاهر اللوحة'),
                      Row(
                        children: [
                          for (final entry in kShopThemeNames.entries) ...[
                            Expanded(
                              child: _ThemeCard(
                                themeKey: entry.key,
                                name: entry.value,
                                owned:
                                    _inventory.ownedThemes.contains(entry.key),
                                selected:
                                    _inventory.selectedTheme == entry.key,
                                onBuy: () => _buy(
                                  ShopPrices.theme,
                                  (i) => i.copyWith(
                                    ownedThemes: {
                                      ...i.ownedThemes,
                                      entry.key,
                                    }.toList(),
                                    selectedTheme: entry.key,
                                  ),
                                  '🎨 اشتريت المظهر!',
                                ),
                                onSelect: () => _selectTheme(entry.key),
                              ),
                            ),
                            if (entry.key != kShopThemeNames.keys.last)
                              const SizedBox(width: 10),
                          ],
                        ],
                      ),
                      const SizedBox(height: 20),

                      // ── Coin packs (real money) ───────────────
                      const _SectionTitle('💎 حزم العملات'),
                      Row(
                        children: [
                          for (final pack in PurchaseService.packs) ...[
                            Expanded(
                              child: _CoinPackCard(
                                pack: pack,
                                onBuy: () => _buyPack(pack),
                              ),
                            ),
                            if (pack != PurchaseService.packs.last)
                              const SizedBox(width: 10),
                          ],
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String text;

  const _SectionTitle(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white70,
          fontSize: 16,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _ShopItemCard extends StatelessWidget {
  final String icon;
  final String name;
  final String description;
  final int price;
  final int owned;
  final String ownedLabel;
  final VoidCallback onBuy;

  const _ShopItemCard({
    required this.icon,
    required this.name,
    required this.description,
    required this.price,
    required this.owned,
    this.ownedLabel = 'مملوك',
    required this.onBuy,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Column(
        children: [
          Text(icon, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 10,
            ),
          ),
          if (owned > 0) ...[
            const SizedBox(height: 4),
            Text(
              '$owned $ownedLabel',
              style: const TextStyle(
                color: Color(0xFF4CAF50),
                fontSize: 10,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFD4AF37),
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                '$price 💰',
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeCard extends StatelessWidget {
  final String themeKey;
  final String name;
  final bool owned;
  final bool selected;
  final VoidCallback onBuy;
  final VoidCallback onSelect;

  const _ThemeCard({
    required this.themeKey,
    required this.name,
    required this.owned,
    required this.selected,
    required this.onBuy,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = BoardThemes.themes[themeKey];
    final light = theme?['light'] ?? Colors.white;
    final dark = theme?['dark'] ?? Colors.black;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: selected
              ? const Color(0xFF4CAF50)
              : Colors.white.withValues(alpha: 0.08),
          width: selected ? 2 : 1,
        ),
      ),
      child: Column(
        children: [
          // Mini board preview (2x2 checker).
          SizedBox(
            width: 44,
            height: 44,
            child: GridView.count(
              crossAxisCount: 2,
              physics: const NeverScrollableScrollPhysics(),
              padding: EdgeInsets.zero,
              children: [
                Container(color: light),
                Container(color: dark),
                Container(color: dark),
                Container(color: light),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            name,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: selected ? null : (owned ? onSelect : onBuy),
              style: ElevatedButton.styleFrom(
                backgroundColor: selected
                    ? const Color(0xFF4CAF50)
                    : owned
                        ? Colors.white.withValues(alpha: 0.15)
                        : const Color(0xFFD4AF37),
                foregroundColor: selected || !owned ? Colors.black : Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                selected
                    ? '✓ مستخدم'
                    : owned
                        ? 'استخدام'
                        : '${ShopPrices.theme} 💰',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CoinPackCard extends StatelessWidget {
  final CoinPack pack;
  final VoidCallback onBuy;

  const _CoinPackCard({required this.pack, required this.onBuy});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFFD4AF37).withValues(alpha: 0.18),
            const Color(0xFFAB86B9).withValues(alpha: 0.12),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        children: [
          const Text('💎', style: TextStyle(fontSize: 28)),
          const SizedBox(height: 6),
          Text(
            '${pack.coins}',
            style: const TextStyle(
              color: Color(0xFFD4AF37),
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          Text(
            'عملة',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.5),
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onBuy,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFAB86B9),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                pack.priceLabel,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w900),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
