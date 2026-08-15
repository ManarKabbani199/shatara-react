import 'package:cloud_firestore/cloud_firestore.dart';

/// User progress for the Shatara Conquest Map (خريطة الفتح).
///
/// Stored under `users/{uid}/conquest/progress` in Firestore.
class ConquestProgressModel {
  /// IDs of territories the player can currently attack.
  final List<String> unlockedTerritories;

  /// IDs of territories the player has already captured.
  final List<String> completedTerritories;

  /// Total coins earned from captured territories.
  final int coins;

  /// Total XP earned from captured territories.
  final int xp;

  /// Last time this progress record was updated.
  final DateTime? lastUpdated;

  const ConquestProgressModel({
    this.unlockedTerritories = const ['T000'],
    this.completedTerritories = const [],
    this.coins = 0,
    this.xp = 0,
    this.lastUpdated,
  });

  factory ConquestProgressModel.fromMap(Map<String, dynamic> map) {
    return ConquestProgressModel(
      unlockedTerritories:
          List<String>.from(map['unlockedTerritories'] ?? ['T000']),
      completedTerritories:
          List<String>.from(map['completedTerritories'] ?? []),
      coins: (map['coins'] as num?)?.toInt() ?? 0,
      xp: (map['xp'] as num?)?.toInt() ?? 0,
      lastUpdated: (map['lastUpdated'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'unlockedTerritories': unlockedTerritories,
      'completedTerritories': completedTerritories,
      'coins': coins,
      'xp': xp,
      'lastUpdated': FieldValue.serverTimestamp(),
    };
  }

  /// Plain JSON serialization for local (guest) storage.
  /// Unlike [toMap], this contains no Firestore sentinels.
  Map<String, dynamic> toJson() {
    return {
      'unlockedTerritories': unlockedTerritories,
      'completedTerritories': completedTerritories,
      'coins': coins,
      'xp': xp,
      'lastUpdated': lastUpdated?.toIso8601String(),
    };
  }

  /// Reads a record written by [toJson] (local guest storage).
  factory ConquestProgressModel.fromJson(Map<String, dynamic> json) {
    return ConquestProgressModel(
      unlockedTerritories:
          List<String>.from(json['unlockedTerritories'] ?? ['T000']),
      completedTerritories:
          List<String>.from(json['completedTerritories'] ?? []),
      coins: (json['coins'] as num?)?.toInt() ?? 0,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      lastUpdated: json['lastUpdated'] is String
          ? DateTime.tryParse(json['lastUpdated'] as String)
          : null,
    );
  }

  ConquestProgressModel copyWith({
    List<String>? unlockedTerritories,
    List<String>? completedTerritories,
    int? coins,
    int? xp,
    DateTime? lastUpdated,
  }) {
    return ConquestProgressModel(
      unlockedTerritories: unlockedTerritories ?? this.unlockedTerritories,
      completedTerritories: completedTerritories ?? this.completedTerritories,
      coins: coins ?? this.coins,
      xp: xp ?? this.xp,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }
}
