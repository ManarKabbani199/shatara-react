import 'package:flutter/material.dart';

/// Asset paths for the Shatara Conquest Map feature.
/// Keep in sync with pubspec.yaml `assets` section.
class MapAssets {
  MapAssets._();

  // Background
  static const String background = 'assets/map/background.svg';

  // Node states
  static const String nodeCastle = 'assets/map/node_castle.svg';
  static const String nodeBattle = 'assets/map/node_battle.svg';
  static const String nodeLocked = 'assets/map/node_locked.svg';
  static const String nodeBoss = 'assets/map/node_boss.svg';
  static const String nodeNeutral = 'assets/map/node_neutral.svg';

  // Paths
  static const String pathActive = 'assets/map/path_active.svg';
  static const String pathLocked = 'assets/map/path_locked.svg';

  // Territory region icons
  static const String iconDesert = 'assets/map/territory_icons/desert.svg';
  static const String iconForest = 'assets/map/territory_icons/forest.svg';
  static const String iconMountain = 'assets/map/territory_icons/mountain.svg';
  static const String iconCity = 'assets/map/territory_icons/city.svg';

  static String iconForRegion(String region) {
    switch (region.toLowerCase()) {
      case 'desert':
        return iconDesert;
      case 'forest':
        return iconForest;
      case 'mountain':
        return iconMountain;
      case 'city':
        return iconCity;
      default:
        return nodeNeutral;
    }
  }
}

/// Arabic display name for each map region.
const Map<String, String> kRegionNames = {
  'starting': 'أراضي البداية',
  'desert': 'فيافي الصحراء',
  'forest': 'مملكة الغابات',
  'mountain': 'ممر الجبال',
  'city': 'إقليم العاصمة',
};

/// Accent color for each map region.
const Map<String, Color> kRegionColors = {
  'starting': Color(0xFF4CAF50),
  'desert': Color(0xFFFF9800),
  'forest': Color(0xFF2E7D32),
  'mountain': Color(0xFF607D8B),
  'city': Color(0xFFAB86B9),
};
