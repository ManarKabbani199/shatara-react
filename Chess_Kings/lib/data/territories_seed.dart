import 'dart:ui';

import 'package:Chess_Cleverness/models/territory_model.dart';

/// Seed data for the Shatara Conquest Map (خريطة الفتح).
///
/// The map contains 30 territories across 5 regions:
/// 1. Starting Lands   (beginner)
/// 2. Desert Wastes    (easy-intermediate)
/// 3. Forest Realm     (intermediate)
/// 4. Mountain Pass    (intermediate-advanced)
/// 5. Capital Region   (advanced + final boss)
///
/// Positions are normalized (0.0 - 1.0) and meant to be rendered inside
/// a Stack using FractionalOffset or FractionallySizedBox.
class TerritoriesSeed {
  TerritoriesSeed._();

  static const List<TerritoryModel> all = [
    // ═══════════════════════════════════════════════════════════
    // REGION 1: Starting Lands
    // ═══════════════════════════════════════════════════════════
    TerritoryModel(
      id: 'T000',
      name: {
        'ar': 'قلعة الفجر',
        'en': 'Castle of Dawn',
      },
      position: Offset(0.12, 0.82),
      connectedTo: ['T001', 'T002'],
      region: 'starting',
      defender: DefenderConfig(
        difficulty: 'مبتدئ',
        aiColor: 'black',
        title: {'ar': 'حارس القلعة', 'en': 'Castle Guard'},
      ),
      rewards: TerritoryRewards(coins: 0, xp: 0),
      isStarting: true,
    ),
    TerritoryModel(
      id: 'T001',
      name: {
        'ar': 'سهول البداية',
        'en': 'Beginner Plains',
      },
      position: Offset(0.22, 0.72),
      connectedTo: ['T000', 'T003', 'T004'],
      region: 'starting',
      defender: DefenderConfig(
        difficulty: 'مبتدئ',
        aiColor: 'black',
        title: {'ar': 'جندي مبتدئ', 'en': 'Novice Soldier'},
      ),
      rewards: TerritoryRewards(coins: 10, xp: 5),
    ),
    TerritoryModel(
      id: 'T002',
      name: {
        'ar': 'مزرعة الوادي',
        'en': 'Valley Farm',
      },
      position: Offset(0.18, 0.62),
      connectedTo: ['T000', 'T004', 'T005'],
      region: 'starting',
      defender: DefenderConfig(
        difficulty: 'مبتدئ',
        aiColor: 'black',
        title: {'ar': 'فلاح محلي', 'en': 'Local Farmer'},
      ),
      rewards: TerritoryRewards(coins: 10, xp: 5),
    ),
    TerritoryModel(
      id: 'T003',
      name: {
        'ar': 'برج الحراسة',
        'en': 'Watchtower',
      },
      position: Offset(0.32, 0.78),
      connectedTo: ['T001', 'T006'],
      region: 'starting',
      defender: DefenderConfig(
        difficulty: 'مبتدئ',
        aiColor: 'black',
        title: {'ar': 'حارس البرج', 'en': 'Tower Watch'},
      ),
      rewards: TerritoryRewards(coins: 15, xp: 8),
    ),
    TerritoryModel(
      id: 'T004',
      name: {
        'ar': 'خيمة التجار',
        'en': 'Merchant Tent',
      },
      position: Offset(0.28, 0.62),
      connectedTo: ['T001', 'T002', 'T005', 'T007'],
      region: 'starting',
      defender: DefenderConfig(
        difficulty: 'مبتدئ',
        aiColor: 'black',
        title: {'ar': 'تاجر مسلح', 'en': 'Armed Merchant'},
      ),
      rewards: TerritoryRewards(coins: 15, xp: 8),
    ),
    TerritoryModel(
      id: 'T005',
      name: {
        'ar': 'معسكر التدريب',
        'en': 'Training Camp',
      },
      position: Offset(0.24, 0.50),
      connectedTo: ['T002', 'T004', 'T008', 'T012'],
      region: 'starting',
      defender: DefenderConfig(
        difficulty: 'متوسط',
        aiColor: 'black',
        title: {'ar': 'مدرب المقاتلين', 'en': 'Drill Instructor'},
      ),
      rewards: TerritoryRewards(coins: 25, xp: 12),
    ),

    // ═══════════════════════════════════════════════════════════
    // REGION 2: Desert Wastes
    // ═══════════════════════════════════════════════════════════
    TerritoryModel(
      id: 'T006',
      name: {
        'ar': 'بوابة الصحراء',
        'en': 'Desert Gate',
      },
      position: Offset(0.42, 0.80),
      connectedTo: ['T003', 'T007', 'T009'],
      region: 'desert',
      defender: DefenderConfig(
        difficulty: 'متوسط',
        aiColor: 'black',
        title: {'ar': 'حارس البوابة', 'en': 'Gate Keeper'},
      ),
      rewards: TerritoryRewards(coins: 25, xp: 12),
    ),
    TerritoryModel(
      id: 'T007',
      name: {
        'ar': 'واحة النخيل',
        'en': 'Palm Oasis',
      },
      position: Offset(0.40, 0.64),
      connectedTo: ['T004', 'T006', 'T008', 'T010'],
      region: 'desert',
      defender: DefenderConfig(
        difficulty: 'متوسط',
        aiColor: 'black',
        title: {'ar': 'رئيس القبيلة', 'en': 'Tribe Chief'},
      ),
      rewards: TerritoryRewards(coins: 25, xp: 12),
    ),
    TerritoryModel(
      id: 'T008',
      name: {
        'ar': 'معسكر الرمال',
        'en': 'Sand Camp',
      },
      position: Offset(0.36, 0.48),
      connectedTo: ['T005', 'T007', 'T010', 'T013'],
      region: 'desert',
      defender: DefenderConfig(
        difficulty: 'متوسط',
        aiColor: 'black',
        title: {'ar': 'قائد الرمال', 'en': 'Sand Commander'},
      ),
      rewards: TerritoryRewards(coins: 30, xp: 15),
    ),
    TerritoryModel(
      id: 'T009',
      name: {
        'ar': 'مقبرة العظماء',
        'en': 'Tomb of Ancients',
      },
      position: Offset(0.52, 0.78),
      connectedTo: ['T006', 'T010', 'T011'],
      region: 'desert',
      defender: DefenderConfig(
        difficulty: 'متوسط',
        aiColor: 'black',
        title: {'ar': 'حارس المقبرة', 'en': 'Tomb Guardian'},
      ),
      rewards: TerritoryRewards(coins: 30, xp: 15),
    ),
    TerritoryModel(
      id: 'T010',
      name: {
        'ar': 'سوق الصحراء',
        'en': 'Desert Bazaar',
      },
      position: Offset(0.48, 0.58),
      connectedTo: ['T007', 'T008', 'T009', 'T011', 'T014'],
      region: 'desert',
      defender: DefenderConfig(
        difficulty: 'متوسط',
        aiColor: 'black',
        title: {'ar': 'تاجر الصحراء', 'en': 'Desert Trader'},
      ),
      rewards: TerritoryRewards(coins: 35, xp: 18),
    ),
    TerritoryModel(
      id: 'T011',
      name: {
        'ar': 'عرين الرياح',
        'en': 'Wind Den',
      },
      position: Offset(0.56, 0.68),
      connectedTo: ['T009', 'T010', 'T015'],
      region: 'desert',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'سيد الرياح', 'en': 'Wind Master'},
      ),
      rewards: TerritoryRewards(coins: 60, xp: 30),
      isBoss: true,
    ),

    // ═══════════════════════════════════════════════════════════
    // REGION 3: Forest Realm
    // ═══════════════════════════════════════════════════════════
    TerritoryModel(
      id: 'T012',
      name: {
        'ar': 'غابة الصنوبر',
        'en': 'Pine Forest',
      },
      position: Offset(0.22, 0.36),
      connectedTo: ['T005', 'T013', 'T016'],
      region: 'forest',
      defender: DefenderConfig(
        difficulty: 'متوسط',
        aiColor: 'black',
        title: {'ar': 'رanger الغابة', 'en': 'Forest Ranger'},
      ),
      rewards: TerritoryRewards(coins: 30, xp: 15),
    ),
    TerritoryModel(
      id: 'T013',
      name: {
        'ar': 'مخبأ اللصوص',
        'en': 'Bandit Hideout',
      },
      position: Offset(0.32, 0.40),
      connectedTo: ['T008', 'T012', 'T014', 'T017'],
      region: 'forest',
      defender: DefenderConfig(
        difficulty: 'متوسط',
        aiColor: 'black',
        title: {'ar': 'زعيم اللصوص', 'en': 'Bandit Leader'},
      ),
      rewards: TerritoryRewards(coins: 35, xp: 18),
    ),
    TerritoryModel(
      id: 'T014',
      name: {
        'ar': 'بحيرة الضباب',
        'en': 'Mist Lake',
      },
      position: Offset(0.44, 0.46),
      connectedTo: ['T010', 'T013', 'T015', 'T018'],
      region: 'forest',
      defender: DefenderConfig(
        difficulty: 'متوسط',
        aiColor: 'black',
        title: {'ar': 'حارس البحيرة', 'en': 'Lake Warden'},
      ),
      rewards: TerritoryRewards(coins: 35, xp: 18),
    ),
    TerritoryModel(
      id: 'T015',
      name: {
        'ar': 'معبد القمر',
        'en': 'Moon Temple',
      },
      position: Offset(0.56, 0.54),
      connectedTo: ['T011', 'T014', 'T019'],
      region: 'forest',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'كاهن القمر', 'en': 'Moon Priest'},
      ),
      rewards: TerritoryRewards(coins: 50, xp: 25),
      isBoss: true,
    ),
    TerritoryModel(
      id: 'T016',
      name: {
        'ar': 'قرية الأقزام',
        'en': 'Dwarf Village',
      },
      position: Offset(0.20, 0.24),
      connectedTo: ['T012', 'T017', 'T020'],
      region: 'forest',
      defender: DefenderConfig(
        difficulty: 'متوسط',
        aiColor: 'black',
        title: {'ar': 'زعيم الأقزام', 'en': 'Dwarf Elder'},
      ),
      rewards: TerritoryRewards(coins: 40, xp: 20),
    ),
    TerritoryModel(
      id: 'T017',
      name: {
        'ar': 'كهف الوحوش',
        'en': 'Beast Cave',
      },
      position: Offset(0.32, 0.28),
      connectedTo: ['T013', 'T016', 'T018', 'T021'],
      region: 'forest',
      defender: DefenderConfig(
        difficulty: 'متوسط',
        aiColor: 'black',
        title: {'ar': 'ملك الوحوش', 'en': 'Beast King'},
      ),
      rewards: TerritoryRewards(coins: 40, xp: 20),
    ),

    // ═══════════════════════════════════════════════════════════
    // REGION 4: Mountain Pass
    // ═══════════════════════════════════════════════════════════
    TerritoryModel(
      id: 'T018',
      name: {
        'ar': 'ممر الجبال',
        'en': 'Mountain Pass',
      },
      position: Offset(0.46, 0.34),
      connectedTo: ['T014', 'T017', 'T019', 'T022'],
      region: 'mountain',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'حارس الممر', 'en': 'Pass Guard'},
      ),
      rewards: TerritoryRewards(coins: 45, xp: 22),
    ),
    TerritoryModel(
      id: 'T019',
      name: {
        'ar': 'قلعة الجليد',
        'en': 'Ice Fortress',
      },
      position: Offset(0.58, 0.40),
      connectedTo: ['T015', 'T018', 'T023', 'T024'],
      region: 'mountain',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'سيد الجليد', 'en': 'Ice Lord'},
      ),
      rewards: TerritoryRewards(coins: 55, xp: 28),
      isBoss: true,
    ),
    TerritoryModel(
      id: 'T020',
      name: {
        'ar': 'منجم الفضة',
        'en': 'Silver Mine',
      },
      position: Offset(0.26, 0.16),
      connectedTo: ['T016', 'T021'],
      region: 'mountain',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'مدير المنجم', 'en': 'Mine Overseer'},
      ),
      rewards: TerritoryRewards(coins: 50, xp: 25),
    ),
    TerritoryModel(
      id: 'T021',
      name: {
        'ar': 'جسر الموت',
        'en': 'Death Bridge',
      },
      position: Offset(0.38, 0.20),
      connectedTo: ['T017', 'T020', 'T022'],
      region: 'mountain',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'حارس الجسر', 'en': 'Bridge Keeper'},
      ),
      rewards: TerritoryRewards(coins: 50, xp: 25),
    ),
    TerritoryModel(
      id: 'T022',
      name: {
        'ar': 'قمة العواصف',
        'en': 'Storm Peak',
      },
      position: Offset(0.48, 0.22),
      connectedTo: ['T018', 'T021', 'T023'],
      region: 'mountain',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'سيد العواصف', 'en': 'Storm Master'},
      ),
      rewards: TerritoryRewards(coins: 55, xp: 28),
    ),
    TerritoryModel(
      id: 'T023',
      name: {
        'ar': 'عش التنين',
        'en': 'Dragon Nest',
      },
      position: Offset(0.58, 0.26),
      connectedTo: ['T019', 'T022', 'T025'],
      region: 'mountain',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'التنين العجوز', 'en': 'Elder Dragon'},
      ),
      rewards: TerritoryRewards(coins: 70, xp: 35),
      isBoss: true,
    ),

    // ═══════════════════════════════════════════════════════════
    // REGION 5: Capital Region
    // ═══════════════════════════════════════════════════════════
    TerritoryModel(
      id: 'T024',
      name: {
        'ar': 'ضواحي العاصمة',
        'en': 'Capital Outskirts',
      },
      position: Offset(0.70, 0.34),
      connectedTo: ['T019', 'T025', 'T026'],
      region: 'city',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'قائد الحرس', 'en': 'Guard Captain'},
      ),
      rewards: TerritoryRewards(coins: 60, xp: 30),
    ),
    TerritoryModel(
      id: 'T025',
      name: {
        'ar': 'سوق العاصمة',
        'en': 'Capital Market',
      },
      position: Offset(0.72, 0.22),
      connectedTo: ['T023', 'T024', 'T027'],
      region: 'city',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'تاجر العاصمة', 'en': 'Capital Merchant'},
      ),
      rewards: TerritoryRewards(coins: 60, xp: 30),
    ),
    TerritoryModel(
      id: 'T026',
      name: {
        'ar': 'ساحة الأبطال',
        'en': 'Heroes Square',
      },
      position: Offset(0.78, 0.44),
      connectedTo: ['T024', 'T027', 'T028'],
      region: 'city',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'بطل الساحة', 'en': 'Arena Champion'},
      ),
      rewards: TerritoryRewards(coins: 65, xp: 32),
    ),
    TerritoryModel(
      id: 'T027',
      name: {
        'ar': 'قصر الملك',
        'en': 'Royal Palace',
      },
      position: Offset(0.82, 0.30),
      connectedTo: ['T025', 'T026', 'T028'],
      region: 'city',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'قائد القصر', 'en': 'Palace Commander'},
      ),
      rewards: TerritoryRewards(coins: 75, xp: 38),
    ),
    TerritoryModel(
      id: 'T028',
      name: {
        'ar': 'برج السحر',
        'en': 'Wizard Tower',
      },
      position: Offset(0.86, 0.46),
      connectedTo: ['T026', 'T027', 'T029'],
      region: 'city',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'الساحر الأعظم', 'en': 'Grand Wizard'},
      ),
      rewards: TerritoryRewards(coins: 80, xp: 40),
    ),
    TerritoryModel(
      id: 'T029',
      name: {
        'ar': 'عرش المملكة',
        'en': 'Throne of the Kingdom',
      },
      position: Offset(0.90, 0.34),
      connectedTo: ['T028'],
      region: 'city',
      defender: DefenderConfig(
        difficulty: 'متقدم',
        aiColor: 'black',
        title: {'ar': 'ملك الظلام', 'en': 'Dark King'},
      ),
      rewards: TerritoryRewards(coins: 200, xp: 100),
      isBoss: true,
    ),
  ];

  /// Lookup map for fast access by territory ID.
  static final Map<String, TerritoryModel> byId = {
    for (final t in all) t.id: t,
  };

  /// Returns all territories belonging to a region.
  static List<TerritoryModel> byRegion(String region) {
    return all.where((t) => t.region == region).toList();
  }

  /// Returns the starting castle territory.
  static TerritoryModel get startingTerritory {
    return all.firstWhere((t) => t.isStarting);
  }

  /// Returns all boss territories.
  static List<TerritoryModel> get bosses {
    return all.where((t) => t.isBoss).toList();
  }

  /// Returns IDs of all territories.
  static List<String> get allIds => all.map((t) => t.id).toList();
}
