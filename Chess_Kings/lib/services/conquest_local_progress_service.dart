import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:Chess_Cleverness/models/conquest_progress_model.dart';
import 'package:Chess_Cleverness/models/territory_model.dart';

/// Stores Shatara Conquest Map progress locally for guest (not logged-in)
/// players using SharedPreferences.
///
/// When the player later logs in, this progress is merged into Firestore via
/// `ConquestProgressService.mergeGuestProgress` and then cleared.
class ConquestLocalProgressService {
  ConquestLocalProgressService._();

  static const String _key = 'conquest_progress_guest';

  /// Returns the locally stored guest progress, or the initial record.
  static Future<ConquestProgressModel> getProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return const ConquestProgressModel();
    try {
      return ConquestProgressModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const ConquestProgressModel();
    }
  }

  /// Persists guest progress locally.
  static Future<void> saveProgress(ConquestProgressModel progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, jsonEncode(progress.toJson()));
  }

  /// Marks a territory as completed and awards its rewards locally.
  ///
  /// Also unlocks all connected territories so the player can advance.
  /// Idempotent: completing the same territory twice grants nothing extra.
  /// [coinMultiplier]/[xpMultiplier] apply active shop boosters.
  static Future<ConquestProgressModel> completeTerritory(
    TerritoryModel territory, {
    int coinMultiplier = 1,
    int xpMultiplier = 1,
  }) async {
    final current = await getProgress();
    if (current.completedTerritories.contains(territory.id)) {
      return current;
    }

    final next = current.copyWith(
      completedTerritories: {
        ...current.completedTerritories,
        territory.id,
      }.toList(),
      unlockedTerritories: {
        ...current.unlockedTerritories,
        ...territory.connectedTo,
      }.toList(),
      coins: current.coins + territory.rewards.coins * coinMultiplier,
      xp: current.xp + territory.rewards.xp * xpMultiplier,
      lastUpdated: DateTime.now(),
    );
    await saveProgress(next);
    return next;
  }

  /// Removes local guest progress (called after a successful merge to
  /// Firestore on login).
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
