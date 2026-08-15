import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'package:Chess_Cleverness/models/territory_model.dart';
import 'package:Chess_Cleverness/services/map_sound_service.dart';

/// Visual state of a territory node on the conquest map.
enum NodeState {
  locked,
  available,
  completed,
}

/// A single tappable territory node on the conquest map.
///
/// Designed with a glowing orb + icon look rather than static SVG icons,
/// giving the map a modern, game-grade feel.
class ConquestMapNode extends StatefulWidget {
  final TerritoryModel territory;
  final NodeState state;
  final VoidCallback? onTap;
  final double size;

  const ConquestMapNode({
    super.key,
    required this.territory,
    required this.state,
    this.onTap,
    this.size = 52,
  });

  @override
  State<ConquestMapNode> createState() => _ConquestMapNodeState();
}

class _ConquestMapNodeState extends State<ConquestMapNode>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  bool _hover = false;
  bool _pressed = false;
  int _shakeNonce = 0;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    if (_isActive) _pulseController.repeat();
  }

  @override
  void didUpdateWidget(covariant ConquestMapNode oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isActive && !_pulseController.isAnimating) {
      _pulseController.repeat();
    } else if (!_isActive && _pulseController.isAnimating) {
      _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  bool get _isLocked => widget.state == NodeState.locked;
  bool get _isCompleted => widget.state == NodeState.completed;
  bool get _isActive => !_isLocked && !_isCompleted;

  Color get _coreColor {
    if (_isCompleted) return const Color(0xFF4CAF50);
    if (widget.territory.isBoss) return const Color(0xFFAB86B9);
    return const Color(0xFFD4AF37);
  }

  Color get _glowColor {
    if (_isCompleted) return const Color(0xFF4CAF50).withValues(alpha: 0.45);
    if (widget.territory.isBoss) return const Color(0xFFAB86B9).withValues(alpha: 0.55);
    return const Color(0xFFD4AF37).withValues(alpha: 0.5);
  }

  String get _icon {
    if (_isLocked) return '🔒';
    if (_isCompleted) return '✓';
    if (widget.territory.isStarting) return '🏰';
    if (widget.territory.isBoss) return '👑';
    return '⚔';
  }

  void _onEnter(PointerEvent _) {
    if (_isLocked) return;
    setState(() => _hover = true);
    MapSoundService.play(MapSfx.hover, volume: 0.7);
  }

  void _onExit(PointerEvent _) {
    setState(() => _hover = false);
  }

  void _handleTap() {
    if (_isLocked) {
      // Locked feedback: armored thud + shake so the tap never feels dead.
      MapSoundService.play(MapSfx.locked);
      setState(() => _shakeNonce++);
      return;
    }
    if (widget.onTap == null) return;
    MapSoundService.play(MapSfx.click);
    widget.onTap!();
  }

  @override
  Widget build(BuildContext context) {
    final effectiveSize = widget.size *
        (_hover ? 1.15 : 1.0) *
        (_pressed ? 0.88 : 1.0);

    Widget node = MouseRegion(
      onEnter: _onEnter,
      onExit: _onExit,
      cursor: _isLocked ? SystemMouseCursors.basic : SystemMouseCursors.click,
      child: GestureDetector(
        onTap: _handleTap,
        onTapDown: _isLocked ? null : (_) => setState(() => _pressed = true),
        onTapUp: _isLocked ? null : (_) => setState(() => _pressed = false),
        onTapCancel:
            _isLocked ? null : () => setState(() => _pressed = false),
        child: SizedBox(
          width: widget.size * 2,
          height: widget.size * 2,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer glow / pulse.
              if (!_isLocked)
                AnimatedBuilder(
                  animation: _pulseController,
                  builder: (context, child) {
                    final t = _pulseController.value;
                    final radius = effectiveSize * (0.9 + t * 0.5);
                    return Container(
                      width: radius,
                      height: radius,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _glowColor.withValues(
                          alpha: _glowColor.a * (1 - t),
                        ),
                      ),
                    );
                  },
                ),
              // Solid aura behind the node.
              if (!_isLocked)
                Container(
                  width: effectiveSize * 1.1,
                  height: effectiveSize * 1.1,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _glowColor,
                        blurRadius: 16,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              // Core node circle.
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: effectiveSize,
                height: effectiveSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      _coreColor,
                      _coreColor.withValues(alpha: 0.7),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: _isLocked ? 0.2 : 0.8),
                    width: 2.5,
                  ),
                ),
              ),
              // Icon.
              Text(
                _icon,
                style: TextStyle(
                  fontSize: widget.size * 0.55,
                  height: 1,
                ),
              ),
              // Rotating boss ring.
              if (widget.territory.isBoss && !_isLocked)
                Animate(
                  effects: [
                    RotateEffect(
                      duration: 18.seconds,
                      begin: 0,
                      end: 1,
                    ),
                  ],
                  onPlay: (controller) => controller.repeat(),
                  child: Container(
                    width: effectiveSize * 1.7,
                    height: effectiveSize * 1.7,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: const Color(0xFFD4AF37).withValues(alpha: 0.6),
                        width: 1.5,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );

    // Locked shake replays on every locked tap (key change restarts it).
    if (_shakeNonce > 0) {
      node = node
          .animate(key: ValueKey(_shakeNonce))
          .shake(hz: 5, offset: const Offset(5, 0), duration: 400.ms);
    }

    // Locked nodes explain themselves on long-press / hover.
    if (_isLocked) {
      node = Tooltip(
        message: 'أكمل الأراضي المجاورة أولاً',
        child: node,
      );
    }

    return node
        .animate(delay: (widget.territory.id == 'T000' ? 0 : 100).ms)
        .fadeIn(duration: 500.ms)
        .scale(
          begin: const Offset(0, 0),
          end: const Offset(1, 1),
          duration: 500.ms,
          curve: Curves.elasticOut,
        );
  }
}
