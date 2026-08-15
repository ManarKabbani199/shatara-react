import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:Chess_Cleverness/data/territories_seed.dart';
import 'package:Chess_Cleverness/models/conquest_progress_model.dart';
import 'package:Chess_Cleverness/models/territory_model.dart';

/// Reads and writes Shatara Conquest Map progress to Firestore.
class ConquestProgressService {
  ConquestProgressService._();

  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static DocumentReference<Map<String, dynamic>> _progressRef(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('conquest')
        .doc('progress');
  }

  /// Returns the user's conquest progress. Creates an initial record if none exists.
  static Future<ConquestProgressModel> getProgress(String uid) async {
    final doc = await _progressRef(uid).get();
    if (!doc.exists || doc.data() == null) {
      final initial = const ConquestProgressModel();
      await _progressRef(uid).set(initial.toMap());
      return initial;
    }
    return ConquestProgressModel.fromMap(doc.data()!);
  }

  /// Stream of real-time conquest progress updates.
  static Stream<ConquestProgressModel> progressStream(String uid) {
    return _progressRef(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return const ConquestProgressModel();
      }
      return ConquestProgressModel.fromMap(doc.data()!);
    });
  }

  /// Marks a territory as unlocked so the player can attack it.
  static Future<void> unlockTerritory(String uid, String territoryId) async {
    await _progressRef(uid).set({
      'unlockedTerritories': FieldValue.arrayUnion([territoryId]),
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  /// Marks a territory as completed and awards its rewards.
  ///
  /// Also unlocks all connected territories so the player can advance.
  /// [coinMultiplier]/[xpMultiplier] apply active shop boosters.
  static Future<void> completeTerritory(
    String uid,
    TerritoryModel territory, {
    int coinMultiplier = 1,
    int xpMultiplier = 1,
  }) async {
    final batch = _firestore.batch();
    final ref = _progressRef(uid);

    batch.update(ref, {
      'completedTerritories': FieldValue.arrayUnion([territory.id]),
      'unlockedTerritories': FieldValue.arrayUnion(territory.connectedTo),
      'coins': FieldValue.increment(territory.rewards.coins * coinMultiplier),
      'xp': FieldValue.increment(territory.rewards.xp * xpMultiplier),
      'lastUpdated': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  /// Merges guest (local) progress into the logged-in user's Firestore
  /// record after login.
  ///
  /// Only territories completed locally but NOT yet completed remotely grant
  /// their coin/XP rewards, so rewards are never double-counted. Unlocked and
  /// completed lists are merged as unions.
  static Future<void> mergeGuestProgress(
    String uid,
    ConquestProgressModel guest,
  ) async {
    if (guest.completedTerritories.isEmpty) return;

    final remote = await getProgress(uid);
    final newlyCompleted = guest.completedTerritories
        .where((id) => !remote.completedTerritories.contains(id))
        .toList();
    if (newlyCompleted.isEmpty) return;

    var coins = 0;
    var xp = 0;
    for (final id in newlyCompleted) {
      final territory = TerritoriesSeed.byId[id];
      if (territory != null) {
        coins += territory.rewards.coins;
        xp += territory.rewards.xp;
      }
    }

    await _progressRef(uid).set({
      'completedTerritories': FieldValue.arrayUnion(guest.completedTerritories),
      'unlockedTerritories': FieldValue.arrayUnion(guest.unlockedTerritories),
      'coins': FieldValue.increment(coins),
      'xp': FieldValue.increment(xp),
      'lastUpdated': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }
}
