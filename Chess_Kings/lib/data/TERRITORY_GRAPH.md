# Shatara Conquest Map — Territory Graph

## Overview

- **Total territories:** 30
- **Starting castle:** T000 — Castle of Dawn
- **Final boss:** T029 — Throne of the Kingdom
- **Mini-bosses:** 5 (T011, T015, T019, T023, T029)
- **Regions:** 5

## Regions & Difficulty Curve

| Region | Territories | Difficulty | Theme |
|--------|-------------|------------|-------|
| Starting Lands | T000–T005 | Beginner — Intermediate | Plains, farms, training camp |
| Desert Wastes | T006–T011 | Intermediate | Desert, oasis, tombs |
| Forest Realm | T012–T017 | Intermediate | Forest, bandits, beasts |
| Mountain Pass | T018–T023 | Intermediate — Advanced | Mountains, ice fortress, dragons |
| Capital Region | T024–T029 | Advanced | City, palace, final throne |

## Bosses

| ID | Name | Region | Rewards |
|----|------|--------|---------|
| T011 | Wind Den | Desert Wastes | 60 coins, 30 XP |
| T015 | Moon Temple | Forest Realm | 50 coins, 25 XP |
| T019 | Ice Fortress | Mountain Pass | 55 coins, 28 XP |
| T023 | Dragon Nest | Mountain Pass | 70 coins, 35 XP |
| T029 | Throne of the Kingdom | Capital Region | 200 coins, 100 XP |

## Key Connections

```
T000 Castle of Dawn
├── T001 Beginner Plains ──┬── T003 Watchtower ── T006 Desert Gate
│                          └── T004 Merchant Tent ──┬── T007 Palm Oasis
│                                                   └── T005 Training Camp
│
T002 Valley Farm ── T005 Training Camp

Desert Wastes:
T006 Desert Gate ──┬── T009 Tomb of Ancients ── T011 Wind Den (BOSS)
T007 Palm Oasis ───┴── T010 Desert Bazaar ───────┘
T008 Sand Camp ──── T010 Desert Bazaar ─── T014 Mist Lake

Forest Realm:
T005 Training Camp ── T012 Pine Forest ── T013 Bandit Hideout ── T014 Mist Lake
T012 Pine Forest ──── T016 Dwarf Village ── T017 Beast Cave
T013 Bandit Hideout ─ T017 Beast Cave

Mountain Pass:
T014 Mist Lake ─── T018 Mountain Pass ── T019 Ice Fortress (BOSS) ── T024 Capital Outskirts
T017 Beast Cave ── T018 Mountain Pass
T016 Dwarf Village ─ T020 Silver Mine ── T021 Death Bridge ── T022 Storm Peak
T021 Death Bridge ── T022 Storm Peak ── T023 Dragon Nest (BOSS)

Capital Region:
T019 Ice Fortress ── T024 Capital Outskirts ──┬── T026 Heroes Square ── T028 Wizard Tower ── T029 Throne (BOSS)
T023 Dragon Nest ── T025 Capital Market ──────┴── T027 Royal Palace ───┘
```

## Reward Totals

- **Total coins available:** ~1,300
- **Total XP available:** ~650

## How to Use

```dart
import 'package:Chess_Cleverness/data/territories_seed.dart';

// All territories
final all = TerritoriesSeed.all;

// Starting castle
final start = TerritoriesSeed.startingTerritory;

// Lookup by ID
final t001 = TerritoriesSeed.byId['T001'];

// Filter by region
final desert = TerritoriesSeed.byRegion('desert');
```
