import 'package:audioplayers/audioplayers.dart';

/// Sound service for the conquest map and campaign battles.
///
/// Sounds live under `assets/sounds/`; call sites pass paths relative to that
/// folder (e.g. `MapSoundService.play(MapSfx.click)`). Players are cached per
/// sound for instant, low-latency playback. Failures are silently ignored so
/// audio never blocks the UI.
class MapSoundService {
  static final Map<String, AudioPlayer> _players = {};
  static bool enabled = true;

  /// Master volume (0.0 – 1.0) applied to every playback.
  static double volume = 1.0;

  static AudioPlayer _playerFor(String key) {
    return _players.putIfAbsent(key, () {
      final player = AudioPlayer();
      player.setPlayerMode(PlayerMode.lowLatency);
      return player;
    });
  }

  /// Plays a sound inside `assets/sounds/` (e.g. `map/click.wav`).
  static Future<void> play(String key, {double volume = 1.0}) async {
    if (!enabled) return;
    try {
      final player = _playerFor(key);
      await player.stop();
      await player.setVolume((MapSoundService.volume * volume).clamp(0.0, 1.0));
      await player.play(AssetSource('sounds/$key'));
    } catch (_) {
      // Audio is best-effort; ignore missing files or platform errors.
    }
  }

  /// Preloads common sounds so first playback has no latency.
  static Future<void> preload() async {
    for (final key in const [
      MapSfx.hover,
      MapSfx.click,
      MapSfx.locked,
    ]) {
      try {
        _playerFor(key);
      } catch (_) {}
    }
  }

  static void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
    _players.clear();
  }
}

/// Sound keys relative to `assets/sounds/`.
class MapSfx {
  MapSfx._();

  // Map UI
  static const hover = 'map/hover.wav';
  static const click = 'map/click.wav';
  static const locked = 'map/locked.wav';
  static const unlock = 'map/unlock.wav';
  static const victory = 'map/victory.wav';
  static const defeat = 'map/defeat.wav';
  static const coins = 'map/coins.wav';
  static const battleStart = 'map/battle_start.wav';
  static const shop = 'map/shop.wav';

  // Gameplay
  static const move = 'move.wav';
  static const capture = 'capture.wav';
  static const check = 'check.wav';
}
