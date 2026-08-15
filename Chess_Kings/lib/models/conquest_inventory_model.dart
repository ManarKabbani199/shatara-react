/// Player inventory for the conquest shop: power-ups, boosters, and
/// cosmetic board themes. Stored alongside conquest progress
/// (Firestore for logged-in players, SharedPreferences for guests).
class ConquestInventoryModel {
  /// 💡 Hint power-ups: highlights the best move during a campaign battle.
  final int hints;

  /// ⏱ Extra-time power-ups: +120 seconds in a campaign battle.
  final int extraTime;

  /// ↩ Undo power-ups: take back the last move pair in a campaign battle.
  final int undos;

  /// Remaining battles with double XP rewards.
  final int xpBoostBattles;

  /// Remaining battles with double coin rewards.
  final int coinBoostBattles;

  /// Board theme keys owned by the player (see BoardThemes).
  final List<String> ownedThemes;

  /// Currently selected board theme key.
  final String selectedTheme;

  const ConquestInventoryModel({
    this.hints = 0,
    this.extraTime = 0,
    this.undos = 0,
    this.xpBoostBattles = 0,
    this.coinBoostBattles = 0,
    this.ownedThemes = const ['brown'],
    this.selectedTheme = 'brown',
  });

  ConquestInventoryModel copyWith({
    int? hints,
    int? extraTime,
    int? undos,
    int? xpBoostBattles,
    int? coinBoostBattles,
    List<String>? ownedThemes,
    String? selectedTheme,
  }) {
    return ConquestInventoryModel(
      hints: hints ?? this.hints,
      extraTime: extraTime ?? this.extraTime,
      undos: undos ?? this.undos,
      xpBoostBattles: xpBoostBattles ?? this.xpBoostBattles,
      coinBoostBattles: coinBoostBattles ?? this.coinBoostBattles,
      ownedThemes: ownedThemes ?? this.ownedThemes,
      selectedTheme: selectedTheme ?? this.selectedTheme,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'hints': hints,
      'extraTime': extraTime,
      'undos': undos,
      'xpBoostBattles': xpBoostBattles,
      'coinBoostBattles': coinBoostBattles,
      'ownedThemes': ownedThemes,
      'selectedTheme': selectedTheme,
    };
  }

  factory ConquestInventoryModel.fromMap(Map<String, dynamic> map) {
    return ConquestInventoryModel(
      hints: (map['hints'] as num?)?.toInt() ?? 0,
      extraTime: (map['extraTime'] as num?)?.toInt() ?? 0,
      undos: (map['undos'] as num?)?.toInt() ?? 0,
      xpBoostBattles: (map['xpBoostBattles'] as num?)?.toInt() ?? 0,
      coinBoostBattles: (map['coinBoostBattles'] as num?)?.toInt() ?? 0,
      ownedThemes:
          List<String>.from(map['ownedThemes'] as List? ?? const ['brown']),
      selectedTheme: map['selectedTheme'] as String? ?? 'brown',
    );
  }

  Map<String, dynamic> toJson() => toMap();

  factory ConquestInventoryModel.fromJson(Map<String, dynamic> json) {
    return ConquestInventoryModel.fromMap(json);
  }
}
