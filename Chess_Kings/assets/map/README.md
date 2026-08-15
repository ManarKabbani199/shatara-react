# Shatara Map Assets

Assets for the Conquest Map feature (`خريطة الفتح`).

## Files

| File | Usage |
|------|-------|
| `background.svg` | Full-screen map background with grid and terrain regions |
| `node_castle.svg` | Player-owned / starting castle territory |
| `node_battle.svg` | Available enemy territory to attack |
| `node_locked.svg` | Locked / inaccessible territory |
| `node_boss.svg` | Boss / final territory |
| `node_neutral.svg` | Neutral region marker |
| `path_active.svg` | Active connection between owned territories |
| `path_locked.svg` | Locked/dashed connection |
| `territory_icons/desert.svg` | Desert region badge |
| `territory_icons/forest.svg` | Forest region badge |
| `territory_icons/mountain.svg` | Mountain region badge |
| `territory_icons/city.svg` | City region badge |

## Brand Colors

- Purple: `#AB86B9`
- Gold: `#D4AF37`
- Cyan: `#5BC0BE`
- Brown: `#6B4E45`
- Dark background: `#050508`
- Panel: `#13131F`

## Usage in Flutter

```dart
import 'package:Chess_Cleverness/core/map_assets.dart';
import 'package:flutter_svg/flutter_svg.dart';

SvgPicture.asset(MapAssets.nodeCastle, width: 64, height: 64)
```

All paths are also listed in `pubspec.yaml` under the `assets` section.
