import 'dart:ui';

/// Represents a single territory node on the Shatara Conquest Map.
class TerritoryModel {
  final String id;

  /// Localized name: { 'ar': '...', 'en': '...' }
  final Map<String, String> name;

  /// Normalized position on the map (0.0 - 1.0).
  /// Use with a Stack + PositionedFractionallySizedBox.
  final Offset position;

  /// IDs of directly connected territories.
  final List<String> connectedTo;

  /// Region/theme used for icon selection and background styling.
  final String region;

  /// Defender configuration for campaign PvE.
  final DefenderConfig defender;

  /// Rewards granted when the territory is captured.
  final TerritoryRewards rewards;

  /// Whether this is a boss / final territory of a region.
  final bool isBoss;

  /// Whether this is the player's starting castle.
  final bool isStarting;

  const TerritoryModel({
    required this.id,
    required this.name,
    required this.position,
    required this.connectedTo,
    required this.region,
    required this.defender,
    required this.rewards,
    this.isBoss = false,
    this.isStarting = false,
  });

  String localizedName(String lang) => name[lang] ?? name['en'] ?? name['ar'] ?? id;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'position': {'x': position.dx, 'y': position.dy},
      'connectedTo': connectedTo,
      'region': region,
      'defender': defender.toMap(),
      'rewards': rewards.toMap(),
      'isBoss': isBoss,
      'isStarting': isStarting,
    };
  }

  factory TerritoryModel.fromMap(Map<String, dynamic> map) {
    final pos = map['position'] as Map<String, dynamic>?;
    return TerritoryModel(
      id: map['id'] as String,
      name: Map<String, String>.from(map['name'] as Map),
      position: Offset(
        (pos?['x'] as num?)?.toDouble() ?? 0.0,
        (pos?['y'] as num?)?.toDouble() ?? 0.0,
      ),
      connectedTo: List<String>.from(map['connectedTo'] as List? ?? []),
      region: map['region'] as String,
      defender: DefenderConfig.fromMap(map['defender'] as Map<String, dynamic>),
      rewards: TerritoryRewards.fromMap(map['rewards'] as Map<String, dynamic>),
      isBoss: map['isBoss'] as bool? ?? false,
      isStarting: map['isStarting'] as bool? ?? false,
    );
  }
}

/// AI defender settings for a territory.
class DefenderConfig {
  /// Difficulty label matching existing AI levels:
  /// 'مبتدئ' (beginner), 'متوسط' (intermediate), 'متقدم' (advanced)
  final String difficulty;

  /// Which side the AI plays.
  final String aiColor;

  /// Optional description of the defender for the UI.
  final Map<String, String>? title;

  const DefenderConfig({
    required this.difficulty,
    required this.aiColor,
    this.title,
  });

  Map<String, dynamic> toMap() {
    return {
      'difficulty': difficulty,
      'aiColor': aiColor,
      if (title != null) 'title': title,
    };
  }

  factory DefenderConfig.fromMap(Map<String, dynamic> map) {
    return DefenderConfig(
      difficulty: map['difficulty'] as String,
      aiColor: map['aiColor'] as String,
      title: map['title'] != null
          ? Map<String, String>.from(map['title'] as Map)
          : null,
    );
  }
}

/// Rewards for capturing a territory.
class TerritoryRewards {
  final int coins;
  final int xp;

  const TerritoryRewards({
    required this.coins,
    required this.xp,
  });

  Map<String, dynamic> toMap() {
    return {
      'coins': coins,
      'xp': xp,
    };
  }

  factory TerritoryRewards.fromMap(Map<String, dynamic> map) {
    return TerritoryRewards(
      coins: (map['coins'] as num?)?.toInt() ?? 0,
      xp: (map['xp'] as num?)?.toInt() ?? 0,
    );
  }
}
