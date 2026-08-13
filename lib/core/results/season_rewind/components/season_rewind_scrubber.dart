import 'dart:async';
import 'dart:math' as math;

import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:flutter/material.dart';

/// Слайдер раундов + play/pause для Season Rewind.
///
/// Рейл рисует [CustomPainter]; во время play — пульс playhead через
/// явный [AnimationController]. Thumb при драге живёт в локальном state —
/// иначе MobX-rebuild в [onChanged] отменяет жест.
class SeasonRewindScrubber extends StatefulWidget {
  const SeasonRewindScrubber({
    required this.races,
    required this.selectedIndex,
    required this.isPlaying,
    required this.canPlay,
    required this.onCommitRound,
    required this.onTogglePlayback,
    required this.onDragStart,
    super.key,
  });

  final List<RacesModel> races;

  /// Последний зафиксированный раунд (после commit / play).
  final int selectedIndex;

  final bool isPlaying;
  final bool canPlay;

  final ValueChanged<int> onCommitRound;
  final VoidCallback onTogglePlayback;
  final VoidCallback onDragStart;

  @override
  State<SeasonRewindScrubber> createState() => _SeasonRewindScrubberState();
}

/// Состояние драга thumb и пульса playhead.
class _SeasonRewindScrubberState extends State<SeasonRewindScrubber>
    with SingleTickerProviderStateMixin {
  int? _dragIndex;
  Timer? _commitDebounce;
  late final AnimationController _pulse;

  int get _thumbIndex {
    final maxIndex = widget.races.length - 1;
    final raw = _dragIndex ?? widget.selectedIndex;
    return raw.clamp(0, maxIndex < 0 ? 0 : maxIndex);
  }

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    if (widget.isPlaying) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant SeasonRewindScrubber oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isPlaying && !_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    } else if (!widget.isPlaying && _pulse.isAnimating) {
      _pulse
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _commitDebounce?.cancel();
    _pulse.dispose();
    super.dispose();
  }

  void _commit(int index) {
    _commitDebounce?.cancel();
    _commitDebounce = Timer(const Duration(milliseconds: 120), () {
      if (!mounted) {
        return;
      }
      widget.onCommitRound(index);
    });
  }

  /// Индекс раунда по локальной X-координате рейла.
  int _indexForDx(double dx, double width, int maxIndex) {
    if (maxIndex <= 0 || width <= 0) {
      return 0;
    }
    final t = (dx / width).clamp(0.0, 1.0);
    return (t * maxIndex).round().clamp(0, maxIndex);
  }

  @override
  Widget build(BuildContext context) {
    final races = widget.races;
    final maxIndex = races.length - 1;
    final thumb = _thumbIndex;
    final race = races[thumb];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(race.raceName, style: AppStyles.body, textAlign: TextAlign.center),
        const SizedBox(height: 4),
        Text(
          context.l10n.seasonRewindRaceOf(thumb + 1, races.length),
          style: AppStyles.caption,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            IconButton(
              tooltip: widget.isPlaying ? context.l10n.seasonRewindPause : context.l10n.seasonRewindPlay,
              onPressed: widget.canPlay ? widget.onTogglePlayback : null,
              icon: Icon(widget.isPlaying ? Icons.pause_circle_filled : Icons.play_circle_filled),
              color: AppTheme.red,
              iconSize: 36,
            ),
            Expanded(
              child: SizedBox(
                height: 40,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth;
                    return GestureDetector(
                      behavior: HitTestBehavior.opaque,
                      onHorizontalDragStart: maxIndex == 0
                          ? null
                          : (details) {
                              widget.onDragStart();
                              setState(
                                () => _dragIndex = _indexForDx(details.localPosition.dx, width, maxIndex),
                              );
                            },
                      onHorizontalDragUpdate: maxIndex == 0
                          ? null
                          : (details) {
                              setState(
                                () => _dragIndex = _indexForDx(details.localPosition.dx, width, maxIndex),
                              );
                            },
                      onHorizontalDragEnd: maxIndex == 0
                          ? null
                          : (_) {
                              final index = _thumbIndex;
                              setState(() => _dragIndex = null);
                              _commit(index);
                            },
                      onTapDown: maxIndex == 0
                          ? null
                          : (details) {
                              widget.onDragStart();
                              final index = _indexForDx(details.localPosition.dx, width, maxIndex);
                              setState(() => _dragIndex = null);
                              _commit(index);
                            },
                      child: AnimatedBuilder(
                        animation: _pulse,
                        builder: (context, _) {
                          return CustomPaint(
                            painter: _SeasonRailPainter(
                              count: races.length,
                              selectedIndex: thumb,
                              pulse: widget.isPlaying ? _pulse.value : 0,
                              active: AppTheme.red,
                              inactive: AppTheme.pink,
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: StaticData.defaultHorizontalPadding / 2),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(context.l10n.roundLabel(races.first.round), style: AppStyles.caption),
              Text(context.l10n.roundLabel(races.last.round), style: AppStyles.caption),
            ],
          ),
        ),
      ],
    );
  }
}

/// Календарный рейл раундов: дорожка, риски этапов и playhead.
class _SeasonRailPainter extends CustomPainter {
  _SeasonRailPainter({
    required this.count,
    required this.selectedIndex,
    required this.pulse,
    required this.active,
    required this.inactive,
  });

  final int count;
  final int selectedIndex;
  final double pulse;
  final Color active;
  final Color inactive;

  @override
  void paint(Canvas canvas, Size size) {
    if (count <= 0 || size.width <= 0) {
      return;
    }

    final cy = size.height / 2;
    const trackH = 4.0;
    final trackRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, cy - trackH / 2, size.width, trackH),
      const Radius.circular(2),
    );
    canvas.drawRRect(trackRect, Paint()..color = inactive);

    final maxIndex = math.max(0, count - 1);
    final t = maxIndex == 0 ? 0.0 : selectedIndex / maxIndex;
    final playX = size.width * t;

    if (playX > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, cy - trackH / 2, playX, trackH),
          const Radius.circular(2),
        ),
        Paint()..color = active,
      );
    }

    // Риски раундов.
    final tickPaint = Paint()
      ..color = active.withValues(alpha: 0.55)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round;
    for (var i = 0; i < count; i++) {
      final x = maxIndex == 0 ? size.width / 2 : size.width * (i / maxIndex);
      canvas.drawLine(Offset(x, cy - 7), Offset(x, cy + 7), tickPaint);
    }

    // Playhead.
    final glow = 2.0 + pulse * 3;
    canvas
      ..drawCircle(
        Offset(playX, cy),
        8 + glow,
        Paint()..color = active.withValues(alpha: 0.18 + 0.12 * pulse),
      )
      ..drawCircle(Offset(playX, cy), 7, Paint()..color = active)
      ..drawCircle(Offset(playX, cy), 3, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant _SeasonRailPainter oldDelegate) {
    return oldDelegate.count != count ||
        oldDelegate.selectedIndex != selectedIndex ||
        oldDelegate.pulse != pulse ||
        oldDelegate.active != active ||
        oldDelegate.inactive != inactive;
  }
}
