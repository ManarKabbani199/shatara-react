import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:Chess_Cleverness/models/conquest_inventory_model.dart';
import 'package:Chess_Cleverness/services/conquest_local_progress_service.dart';
import 'package:Chess_Cleverness/services/conquest_progress_service.dart';

/// Stores the conquest shop inventory (power-ups, boosters, themes).
///
/// Logged-in players: Firestore `users/{uid}/conquest/inventory`.
/// Guests: SharedPreferences, merged into Firestore on login (consumables
/// are summed, owned themes unioned) then cleared.
class ConquestInventoryService {
  ConquestInventoryService._();

  static const String _localKey = 'conquest_inventory_guest';
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static DocumentReference<Map<String, dynamic>> _ref(String uid) {
    return _firestore
        .collection('users')
        .doc(uid)
        .collection('conquest')
        .doc('inventory');
  }

  /// Returns the player's inventory (guest-safe when [uid] is null).
  static Future<ConquestInventoryModel> getInventory(String? uid) async {
    if (uid == null) return _getLocal();
    final doc = await _ref(uid).get();
    if (!doc.exists || doc.data() == null) {
      return const ConquestInventoryModel();
    }
    return ConquestInventoryModel.fromMap(doc.data()!);
  }

  /// Live stream for logged-in players (null for guests).
  static Stream<ConquestInventoryModel>? inventoryStream(String? uid) {
    if (uid == null) return null;
    return _ref(uid).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        return const ConquestInventoryModel();
      }
      return ConquestInventoryModel.fromMap(doc.data()!);
    });
  }

  static Future<void> saveInventory(
    String? uid,
    ConquestInventoryModel inventory,
  ) async {
    if (uid == null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_localKey, jsonEncode(inventory.toJson()));
      return;
    }
    await _ref(uid).set(inventory.toMap());
  }

  /// Attempts a coin purchase: deducts [cost] coins from conquest progress
  /// and applies [apply] to the inventory. Returns false when the player
  /// cannot afford it (nothing is written).
  static Future<bool> tryPurchase(
    String? uid,
    int cost,
    ConquestInventoryModel Function(ConquestInventoryModel inventory) apply,
  ) async {
    if (uid == null) {
      final progress = await ConquestLocalProgressService.getProgress();
      if (progress.coins < cost) return false;
      final inventory = await _getLocal();
      await ConquestLocalProgressService.saveProgress(
        progress.copyWith(coins: progress.coins - cost),
      );
      await saveInventory(null, apply(inventory));
      return true;
    }

    final progress = await ConquestProgressService.getProgress(uid);
    if (progress.coins < cost) return false;
    final inventory = await getInventory(uid);
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('conquest')
        .doc('progress')
        .update({'coins': FieldValue.increment(-cost)});
    await saveInventory(uid, apply(inventory));
    return true;
  }

  /// Adds coins bought with real money (coin packs).
  static Future<void> grantCoins(String? uid, int amount) async {
    if (uid == null) {
      final progress = await ConquestLocalProgressService.getProgress();
      await ConquestLocalProgressService.saveProgress(
        progress.copyWith(coins: progress.coins + amount),
      );
      return;
    }
    await _firestore
        .collection('users')
        .doc(uid)
        .collection('conquest')
        .doc('progress')
        .update({'coins': FieldValue.increment(amount)});
  }

  /// Merges guest inventory into Firestore on login, then clears local data.
  static Future<void> mergeGuestInventory(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_localKey);
    if (raw == null) return;

    ConquestInventoryModel guest;
    try {
      guest = ConquestInventoryModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      await prefs.remove(_localKey);
      return;
    }

    final remote = await getInventory(uid);
    final merged = remote.copyWith(
      hints: remote.hints + guest.hints,
      extraTime: remote.extraTime + guest.extraTime,
      undos: remote.undos + guest.undos,
      xpBoostBattles: remote.xpBoostBattles + guest.xpBoostBattles,
      coinBoostBattles: remote.coinBoostBattles + guest.coinBoostBattles,
      ownedThemes: {...remote.ownedThemes, ...guest.ownedThemes}.toList(),
    );
    await saveInventory(uid, merged);
    await prefs.remove(_localKey);
  }

  static Future<ConquestInventoryModel> _getLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_localKey);
    if (raw == null) return const ConquestInventoryModel();
    try {
      return ConquestInventoryModel.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    } catch (_) {
      return const ConquestInventoryModel();
    }
  }
}
