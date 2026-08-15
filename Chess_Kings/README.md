# chess_kings

A new Flutter project.

## Conquest Map (خريطة الفتح)

Campaign mode: 30 territories, 5 regions, 5 bosses. Win one Shatara match
against a territory's defender to capture it, unlock adjacent lands, and
earn coins/XP.

- **Route**: `/conquest` → `lib/screens/ConquestMapScreen.dart` (live progress
  via Firestore stream; unlock/region/boss celebrations).
- **Map widgets**: `lib/Widget/ConquestMap/` (`conquest_map_node.dart`,
  `territory_detail_sheet.dart`, `unlock_celebration.dart`).
- **Data**: `lib/data/territories_seed.dart` (graph, defenders, rewards) +
  `lib/data/TERRITORY_GRAPH.md`; region metadata in `lib/core/map_assets.dart`.
- **Battle integration**: `ChessBoard(territory: t)` in
  `lib/screens/GamePLay/ChessBoard.dart` runs a campaign battle (defender
  difficulty/color from the seed). `isReplay: true` replays a captured
  territory without granting rewards again.
- **Progress storage**:
  - Logged-in: Firestore `users/{uid}/conquest/progress` via
    `lib/services/conquest_progress_service.dart` (see `firestore.rules`).
  - Guest: local SharedPreferences via
    `lib/services/conquest_local_progress_service.dart`; merged into
    Firestore on next login (`mergeGuestProgress`, rewards never
    double-counted).
- **Sounds**: `lib/services/map_sound_service.dart` + `assets/sounds/map/`.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
