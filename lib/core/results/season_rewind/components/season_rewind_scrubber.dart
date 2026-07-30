import 'dart:async';

import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:flutter/material.dart';

/// Слайдер раундов + play/pause для Season Rewind.
///
/// Thumb во время драга живёт в локальном state — иначе MobX-rebuild в
/// [onChanged] отменяет жест и [onChangeEnd] не вызывается (очки не грузятся).
class SeasonRewindScrubber extends StatefulWidget {
  const SeasonRewindScrubber({
    required this.races,
    required this.selectedIndex,
    required this.isPlaying,
    required this.canPlay,
    required this.isLoadingStandings,
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

  /// Идёт загрузка standings для [selectedIndex].
  final bool isLoadingStandings;

  final ValueChanged<int> onCommitRound;
  final VoidCallback onTogglePlayback;
  final VoidCallback onDragStart;

  @override
  State<SeasonRewindScrubber> createState() => _SeasonRewindScrubberState();
}

class _SeasonRewindScrubberState extends State<SeasonRewindScrubber> {
  int? _dragIndex;
  Timer? _commitDebounce;

  int get _thumbIndex {
    final maxIndex = widget.races.length - 1;
    final raw = _dragIndex ?? widget.selectedIndex;
    return raw.clamp(0, maxIndex < 0 ? 0 : maxIndex);
  }

  @override
  void dispose() {
    _commitDebounce?.cancel();
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
        if (widget.isLoadingStandings) ...[
          const SizedBox(height: 8),
          const ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(2)),
            child: LinearProgressIndicator(
              minHeight: 2,
              color: AppTheme.red,
              backgroundColor: AppTheme.pink,
            ),
          ),
        ],
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
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: AppTheme.red,
                  inactiveTrackColor: AppTheme.pink,
                  thumbColor: AppTheme.red,
                  overlayColor: AppTheme.red.withValues(alpha: 0.12),
                ),
                child: Slider(
                  value: thumb.toDouble(),
                  min: 0,
                  max: maxIndex.toDouble(),
                  divisions: maxIndex > 0 ? maxIndex : null,
                  label: race.round,
                  onChangeStart: maxIndex == 0
                      ? null
                      : (value) {
                          widget.onDragStart();
                          setState(() => _dragIndex = value.round().clamp(0, maxIndex));
                        },
                  onChanged: maxIndex == 0
                      ? null
                      : (value) {
                          setState(() => _dragIndex = value.round().clamp(0, maxIndex));
                        },
                  onChangeEnd: maxIndex == 0
                      ? null
                      : (value) {
                          final index = value.round().clamp(0, maxIndex);
                          setState(() => _dragIndex = null);
                          _commit(index);
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
