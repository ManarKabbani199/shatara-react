import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:Chess_Cleverness/Widget/ConquestMap/conquest_map_node.dart';
import 'package:Chess_Cleverness/Widget/ConquestMap/shop_sheet.dart';
import 'package:Chess_Cleverness/Widget/ConquestMap/territory_detail_sheet.dart';
import 'package:Chess_Cleverness/Widget/ConquestMap/unlock_celebration.dart';
import 'package:Chess_Cleverness/core/map_assets.dart';
import 'package:Chess_Cleverness/data/territories_seed.dart';
import 'package:Chess_Cleverness/models/conquest_progress_model.dart';
import 'package:Chess_Cleverness/models/territory_model.dart';
import 'package:Chess_Cleverness/services/conquest_inventory_service.dart';
import 'package:Chess_Cleverness/services/conquest_local_progress_service.dart';
import 'package:Chess_Cleverness/services/conquest_progress_service.dart';
import 'package:Chess_Cleverness/services/map_sound_service.dart';
import 'package:Chess_Cleverness/screens/GamePLay/ChessBoard.dart';

/// Background SVG viewBox size.
const double _kMapWidth = 1440.0;
const double _kMapHeight = 900.0;

/// Interactive conquest map screen for Shatara Kings.
///
/// Features a modern dark-fantasy aesthetic with glowing nodes,
/// animated flowing paths, ambient particles, and sound feedback.
class ConquestMapScreen extends StatefulWidget {
  const ConquestMapScreen({super.key});

  @override
  State<ConquestMapScreen> createState() => _ConquestMapScreenState();
}

class _ConquestMapScreenState extends State<ConquestMapScreen>
    with TickerProviderStateMixin {
  static final List<TerritoryModel> _territories = TerritoriesSeed.all;

  ConquestProgressModel? _progress;
  bool _loading = true;
  String? _error;

  /// Null means the player is a guest — progress is stored locally.
  User? _user;
  StreamSubscription<ConquestProgressModel>? _progressSub;

  /// True while a battle route is on top of the map. Stream updates that
  /// arrive during the battle only refresh state; the celebration is
  /// deferred until the player returns to the map.
  bool _inBattle = false;

  late final AnimationController _pathController;

  /// Persistent particle painter — hoisted so particles keep their state
  /// across rebuilds instead of re-randomizing every frame.
  final _ParticlePainter _particlePainter = _ParticlePainter();

  /// Scroll controllers used to auto-focus newly unlocked territories.
  final ScrollController _hScrollController = ScrollController();
  final ScrollController _vScrollController = ScrollController();

  /// Last laid-out map size, kept for scroll-to-territory math.
  double _mapWidth = 0;
  double _mapHeight = 0;

  @override
  void initState() {
    super.initState();
    _pathController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
    _user = FirebaseAuth.instance.currentUser;
    MapSoundService.preload();
    _initProgress();
  }

  @override
  void dispose() {
    _progressSub?.cancel();
    _pathController.dispose();
    _hScrollController.dispose();
    _vScrollController.dispose();
    super.dispose();
  }

  /// Starts progress tracking: a live Firestore stream for logged-in
  /// players (after merging any guest progress), or local storage for guests.
  Future<void> _initProgress() async {
    await _progressSub?.cancel();
    _progressSub = null;

    final user = _user;
    if (user == null) {
      await _loadGuestProgress();
      return;
    }

    try {
      // Carry over any progress earned as a guest (one-time merge).
      final guest = await ConquestLocalProgressService.getProgress();
      if (guest.completedTerritories.isNotEmpty) {
        await ConquestProgressService.mergeGuestProgress(user.uid, guest);
        await ConquestLocalProgressService.clear();
      }
      // Carry over any shop inventory earned as a guest (one-time merge).
      await ConquestInventoryService.mergeGuestInventory(user.uid);
      // Ensure the progress document exists before listening.
      await ConquestProgressService.getProgress(user.uid);
    } catch (_) {
      // Merge/bootstrap failures are non-fatal; the stream may still work.
    }

    _progressSub = ConquestProgressService.progressStream(user.uid).listen(
      _onProgress,
      onError: (_) {
        if (mounted) {
          setState(() {
            _error = 'فشل تحميل تقدم اللعبة';
            _loading = false;
          });
        }
      },
    );
  }

  Future<void> _loadGuestProgress() async {
    try {
      final progress = await ConquestLocalProgressService.getProgress();
      _onProgress(progress);
    } catch (_) {
      if (mounted) {
        setState(() {
          _error = 'فشل تحميل تقدم اللعبة';
          _loading = false;
        });
      }
    }
  }

  void _onProgress(ConquestProgressModel next) {
    final prev = _progress;
    if (!mounted) return;
    setState(() {
      _progress = next;
      _loading = false;
      _error = null;
    });
    if (prev != null && !_inBattle) _maybeCelebrate(prev, next);
  }

  /// Detects newly unlocked/completed territories between two progress
  /// snapshots and shows the celebration sheet with the unlock sound.
  void _maybeCelebrate(
    ConquestProgressModel prev,
    ConquestProgressModel next,
  ) {
    final newCompleted = next.completedTerritories
        .where((id) => !prev.completedTerritories.contains(id))
        .toList();
    final newUnlocked = next.unlockedTerritories
        .where((id) =>
            !prev.unlockedTerritories.contains(id) &&
            !next.completedTerritories.contains(id))
        .toList();

    if (newCompleted.isEmpty && newUnlocked.isEmpty) return;

    final defeatedBosses = newCompleted
        .map((id) => TerritoriesSeed.byId[id])
        .whereType<TerritoryModel>()
        .where((t) => t.isBoss)
        .map((t) => t.name['ar'] ?? t.name['en'] ?? t.id)
        .toList();

    final completedRegions = <String>[];
    for (final region in kRegionNames.keys) {
      final ids = TerritoriesSeed.byRegion(region).map((t) => t.id).toList();
      final wasComplete =
          ids.every((id) => prev.completedTerritories.contains(id));
      final isComplete =
          ids.every((id) => next.completedTerritories.contains(id));
      if (isComplete && !wasComplete) completedRegions.add(region);
    }

    final unlockedNames = newUnlocked
        .map((id) => TerritoriesSeed.byId[id])
        .whereType<TerritoryModel>()
        .map((t) => t.name['ar'] ?? t.name['en'] ?? t.id)
        .toList();

    // Final victory: every territory completed in this update.
    final totalTerritories = TerritoriesSeed.all.length;
    final isFinalVictory =
        next.completedTerritories.length >= totalTerritories &&
        prev.completedTerritories.length < totalTerritories;

    MapSoundService.play(isFinalVictory ? MapSfx.victory : MapSfx.unlock);
    if (newCompleted.isNotEmpty) {
      // Rewards were earned — cascade the coins right after the fanfare.
      Future.delayed(const Duration(milliseconds: 600), () {
        MapSoundService.play(MapSfx.coins);
      });
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      UnlockCelebrationSheet.show(
        context,
        unlockedNames: unlockedNames,
        defeatedBossNames: defeatedBosses,
        completedRegions: completedRegions,
        isFinalVictory: isFinalVictory,
        totalCoins: next.coins,
        totalXp: next.xp,
      );
    });
  }

  NodeState _nodeStateFor(TerritoryModel territory) {
    final progress = _progress;
    if (progress == null) return NodeState.locked;

    if (progress.completedTerritories.contains(territory.id)) {
      return NodeState.completed;
    }
    if (progress.unlockedTerritories.contains(territory.id)) {
      return NodeState.available;
    }
    return NodeState.locked;
  }

  void _onNodeTap(TerritoryModel territory) {
    final state = _nodeStateFor(territory);
    if (state == NodeState.locked) return;

    final alreadyCompleted = state == NodeState.completed;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TerritoryDetailSheet(
        territory: territory,
        alreadyCompleted: alreadyCompleted,
        onStartBattle: () {
          Navigator.of(context).pop();
          _startBattle(territory);
        },
        onReplayBattle: alreadyCompleted
            ? () {
                Navigator.of(context).pop();
                _startBattle(territory, isReplay: true);
              }
            : null,
        onOpenShop: () {
          Navigator.of(context).pop();
          ConquestShopSheet.show(this.context);
        },
      ),
    );
  }

  Future<void> _startBattle(
    TerritoryModel territory, {
    bool isReplay = false,
  }) async {
    MapSoundService.play(MapSfx.battleStart);
    _inBattle = true;
    final baseline = _progress;
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            ChessBoard(territory: territory, isReplay: isReplay),
      ),
    );
    _inBattle = false;
    if (!mounted) return;
    if (_user == null) {
      // Guests have no live stream — reload local progress after the battle.
      // _onProgress diffs against the pre-battle snapshot and celebrates.
      await _loadGuestProgress();
    } else {
      // Logged-in players: celebrate any progress that arrived via the
      // Firestore stream while the battle was on top.
      final current = _progress;
      if (baseline != null && current != null) {
        _maybeCelebrate(baseline, current);
      }
    }
    if (!mounted) return;
    // If the battle opened new lands, gently pan the map to the next
    // available territory so the player sees where to go next.
    final after = _progress;
    if (after != null &&
        baseline != null &&
        after.completedTerritories.length >
            baseline.completedTerritories.length) {
      _focusNextTerritory();
    }
  }

  /// Animates the scroll views to the first unlocked-but-not-completed
  /// territory (usually the one just unlocked).
  void _focusNextTerritory() {
    if (_mapWidth == 0) return;
    final progress = _progress;
    if (progress == null) return;

    TerritoryModel? target;
    for (final t in _territories) {
      final unlocked = progress.unlockedTerritories.contains(t.id);
      final completed = progress.completedTerritories.contains(t.id);
      if (unlocked && !completed) {
        target = t;
        break;
      }
    }
    if (target == null) return;

    final x = target.position.dx * _mapWidth;
    final y = target.position.dy * _mapHeight;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (_hScrollController.hasClients) {
        final max = _hScrollController.position.maxScrollExtent;
        _hScrollController.animateTo(
          (x - 300).clamp(0.0, max),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOutCubic,
        );
      }
      if (_vScrollController.hasClients) {
        final max = _vScrollController.position.maxScrollExtent;
        _vScrollController.animateTo(
          (y - 250).clamp(0.0, max),
          duration: const Duration(milliseconds: 900),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  void _toggleSound() {
    MapSoundService.enabled = !MapSoundService.enabled;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          MapSoundService.enabled ? 'تم تفعيل الصوت' : 'تم كتم الصوت',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Compact mode for narrow (mobile) screens.
    final compact = MediaQuery.sizeOf(context).width < 480;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFF050508),
        appBar: AppBar(
          backgroundColor: const Color(0xFF050508),
          elevation: 0,
          centerTitle: true,
          title: Text(
            'خريطة الفتح',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: compact ? 17 : 24,
            ),
          ),
          actions: [
            _buildStatChip(
              '🏰',
              '${_progress?.completedTerritories.length ?? 0}/30',
              compact,
            ),
            // Coin chip doubles as the shop entrance.
            GestureDetector(
              onTap: () => ConquestShopSheet.show(context),
              child: _buildStatChip(
                '💰',
                '${_progress?.coins ?? 0}',
                compact,
              ),
            ),
            _buildStatChip('⭐', '${_progress?.xp ?? 0}', compact),
            IconButton(
              tooltip: 'المتجر',
              iconSize: compact ? 20 : 24,
              visualDensity: compact ? VisualDensity.compact : null,
              icon: const Icon(
                Icons.storefront,
                color: Color(0xFFD4AF37),
              ),
              onPressed: () => ConquestShopSheet.show(context),
            ),
            IconButton(
              iconSize: compact ? 20 : 24,
              visualDensity: compact ? VisualDensity.compact : null,
              icon: Icon(
                MapSoundService.enabled ? Icons.volume_up : Icons.volume_off,
                color: Colors.white70,
              ),
              onPressed: _toggleSound,
            ),
            SizedBox(width: compact ? 2 : 8),
          ],
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: _buildBody(),
      ),
    );
  }

  Widget _buildStatChip(String icon, String value, [bool compact = false]) {
    return Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: compact ? 1.5 : 4),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 6 : 12,
          vertical: compact ? 4 : 6,
        ),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.1),
          ),
        ),
        child: Text(
          '$icon $value',
          style: TextStyle(
            color: Colors.white,
            fontSize: compact ? 10 : 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFD4AF37)),
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _error!,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _loading = true;
                  _error = null;
                });
                _initProgress();
              },
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        // Responsive: on small screens the map keeps a playable minimum
        // width and pans horizontally instead of squishing all 30 nodes
        // into a tiny area.
        const double minMapWidth = 960;
        final width = math.max(constraints.maxWidth - 24, minMapWidth);
        final height = width * _kMapHeight / _kMapWidth;
        // Node diameter scales with the map (56 logical px at full width).
        final nodeSize = width * 56 / _kMapWidth;
        _mapWidth = width;
        _mapHeight = height;

        return SingleChildScrollView(
          controller: _hScrollController,
          scrollDirection: Axis.horizontal,
          child: SingleChildScrollView(
            controller: _vScrollController,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: Container(
                  width: width,
                  height: height,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFAB86B9).withValues(alpha: 0.15),
                        blurRadius: 40,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // Static base gradient.
                      Container(
                        decoration: const BoxDecoration(
                          gradient: RadialGradient(
                            center: Alignment(-0.6, 0.6),
                            radius: 1.2,
                            colors: [Color(0xFF1A1625), Color(0xFF050508)],
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        MapAssets.background,
                        fit: BoxFit.fill,
                      ),
                      // Reactive atmosphere + living particles + glowing
                      // curved paths, all driven by the map ticker.
                      AnimatedBuilder(
                        animation: _pathController,
                        builder: (context, child) {
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              _AtmosphereBackground(
                                territories: _territories,
                                progress: _progress,
                                phase: _pathController.value,
                              ),
                              CustomPaint(
                                size: Size(width, height),
                                painter: _particlePainter,
                              ),
                              CustomPaint(
                                size: Size(width, height),
                                painter: _MapPathPainter(
                                  territories: _territories,
                                  progress: _progress,
                                  phase: _pathController.value,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      // Territory nodes.
                      ..._territories.map(
                        (t) => _buildNode(t, width, height, nodeSize),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildNode(
    TerritoryModel territory,
    double width,
    double height,
    double nodeSize,
  ) {
    final state = _nodeStateFor(territory);
    final x = territory.position.dx * width;
    final y = territory.position.dy * height;

    return Positioned(
      left: x - nodeSize,
      top: y - nodeSize,
      child: ConquestMapNode(
        territory: territory,
        state: state,
        onTap: () => _onNodeTap(territory),
        size: nodeSize,
      ),
    );
  }
}

/// Region atmosphere glows that react to player progress and pulse slowly.
class _AtmosphereBackground extends StatelessWidget {
  final List<TerritoryModel> territories;
  final ConquestProgressModel? progress;
  final double phase;

  const _AtmosphereBackground({
    required this.territories,
    required this.progress,
    required this.phase,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _AtmospherePainter(
        territories: territories,
        progress: progress,
        phase: phase,
      ),
    );
  }
}

/// Paints soft, pulsing glow blobs over regions the player has reached.
class _AtmospherePainter extends CustomPainter {
  final List<TerritoryModel> territories;
  final ConquestProgressModel? progress;
  final double phase;

  _AtmospherePainter({
    required this.territories,
    required this.progress,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final pulse = 0.10 + 0.05 * math.sin(2 * math.pi * phase);

    final byRegion = <String, List<TerritoryModel>>{};
    for (final t in territories) {
      byRegion.putIfAbsent(t.region, () => []).add(t);
    }

    byRegion.forEach((region, list) {
      final reached = list.any(
        (t) => progress?.unlockedTerritories.contains(t.id) ?? false,
      );
      if (!reached) return;

      final color = kRegionColors[region] ?? const Color(0xFFD4AF37);
      final cx = list.map((t) => t.position.dx).reduce((a, b) => a + b) /
          list.length *
          size.width;
      final cy = list.map((t) => t.position.dy).reduce((a, b) => a + b) /
          list.length *
          size.height;
      final center = Offset(cx, cy);
      final radius = size.width * 0.22;

      final glow = Paint()
        ..shader = RadialGradient(
          colors: [
            color.withValues(alpha: pulse),
            color.withValues(alpha: 0),
          ],
        ).createShader(Rect.fromCircle(center: center, radius: radius));
      canvas.drawCircle(center, radius, glow);
    });
  }

  @override
  bool shouldRepaint(covariant _AtmospherePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.phase != phase;
  }
}

/// Floating ambient particle layer drawn over the map.
class _ParticlePainter extends CustomPainter {
  final math.Random _random = math.Random(42);
  late final List<_Particle> _particles = List.generate(
    40,
    (_) => _Particle.random(_random),
  );

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.fill;

    for (final p in _particles) {
      p.update(size);
      paint.color = p.color.withValues(alpha: p.opacity);
      canvas.drawCircle(Offset(p.x * size.width, p.y * size.height), p.radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Particle {
  double x, y;
  double radius;
  double speedX, speedY;
  double opacity;
  Color color;

  _Particle({
    required this.x,
    required this.y,
    required this.radius,
    required this.speedX,
    required this.speedY,
    required this.opacity,
    required this.color,
  });

  factory _Particle.random(math.Random random) {
    return _Particle(
      x: random.nextDouble(),
      y: random.nextDouble(),
      radius: random.nextDouble() * 1.8 + 0.6,
      speedX: (random.nextDouble() - 0.5) * 0.0008,
      speedY: (random.nextDouble() - 0.5) * 0.0008 - 0.0003,
      opacity: random.nextDouble() * 0.5 + 0.2,
      color: random.nextBool()
          ? const Color(0xFFD4AF37)
          : random.nextBool()
              ? const Color(0xFFAB86B9)
              : Colors.white,
    );
  }

  void update(Size size) {
    x += speedX;
    y += speedY;
    if (y < -0.05 || x < -0.05 || x > 1.05) {
      y = 1.05;
      x = math.Random().nextDouble();
    }
  }
}

/// Paints connection paths between territories with glow and flowing dashes.
class _MapPathPainter extends CustomPainter {
  final List<TerritoryModel> territories;
  final ConquestProgressModel? progress;
  final double phase;

  _MapPathPainter({
    required this.territories,
    required this.progress,
    required this.phase,
  });

  bool _isUnlocked(String id) {
    return progress?.unlockedTerritories.contains(id) ?? false;
  }

  bool _isCompleted(String id) {
    return progress?.completedTerritories.contains(id) ?? false;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final unlockedPaint = Paint()
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFFD4AF37).withValues(alpha: 0.9)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final completedPaint = Paint()
      ..strokeWidth = 3.5
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF4CAF50).withValues(alpha: 0.85)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final lockedPaint = Paint()
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..color = const Color(0xFF2A2538);

    final dashPaint = Paint()
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..color = Colors.white.withValues(alpha: 0.6);

    for (final territory in territories) {
      final start = Offset(
        territory.position.dx * size.width,
        territory.position.dy * size.height,
      );

      for (final connectedId in territory.connectedTo) {
        final connected = TerritoriesSeed.byId[connectedId];
        if (connected == null) continue;

        // Only draw from lower ID to higher ID to avoid duplicate lines.
        if (territory.id.compareTo(connectedId) >= 0) continue;

        final end = Offset(
          connected.position.dx * size.width,
          connected.position.dy * size.height,
        );

        final isActive = _isUnlocked(territory.id) && _isUnlocked(connectedId);
        final isCompleted =
            _isCompleted(territory.id) && _isCompleted(connectedId);

        final path = _curvedPath(start, end);

        if (isCompleted) {
          canvas.drawPath(path, completedPaint);
        } else if (isActive) {
          canvas.drawPath(path, unlockedPaint);
          _drawFlowingDashes(canvas, path, dashPaint);
        } else {
          canvas.drawPath(path, lockedPaint);
        }
      }
    }
  }

  /// A gentle quadratic arc between two nodes — feels more organic than a
  /// straight line.
  Path _curvedPath(Offset start, Offset end) {
    final delta = end - start;
    final distance = delta.distance;
    if (distance == 0) {
      return Path()..moveTo(start.dx, start.dy);
    }
    final mid = (start + end) / 2;
    final normal = Offset(-delta.dy, delta.dx) / distance;
    final control = mid + normal * distance * 0.08;
    return Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
  }

  void _drawFlowingDashes(Canvas canvas, Path path, Paint paint) {
    const dash = 10.0;
    const gap = 12.0;
    final offset = phase * (dash + gap);

    for (final metric in path.computeMetrics()) {
      double current = -offset;
      while (current < metric.length) {
        final a = current.clamp(0.0, metric.length);
        final b = (current + dash).clamp(0.0, metric.length);
        if (b > a) {
          canvas.drawPath(metric.extractPath(a, b), paint);
        }
        current += dash + gap;
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MapPathPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.phase != phase;
  }
}
