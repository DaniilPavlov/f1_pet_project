import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/common/widgets/circuits/circuit_layout_image.dart';
import 'package:f1_pet_project/core/circuits/stats/circuit_layout_assets.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Крупная карточка ближайшей (или последней) гонки со схемой и countdown.
class ScheduleRaceFeaturedCard extends StatelessWidget {
  const ScheduleRaceFeaturedCard({
    required this.race,
    required this.countdown,
    required this.showCountdown,
    required this.onViewSchedule,
    super.key,
  });

  final RacesModel race;
  final CountdownParts countdown;
  final bool showCountdown;
  final VoidCallback onViewSchedule;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toLanguageTag();
    final start = RaceDateTimeHelper.weekendStart(race);
    final end = RaceDateTimeHelper.raceLocal(race);
    final dateRange = start.year == end.year && start.month == end.month && start.day == end.day
        ? DateFormat.yMMMMd(locale).format(end)
        : '${DateFormat.d(locale).format(start)} – ${DateFormat.yMMMMd(locale).format(end)}';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.red),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(context.l10n.scheduleRound(race.round), style: AppStyles.caption.copyWith(color: AppTheme.textGray)),
          const SizedBox(height: 4),
          Text(race.raceName, style: AppStyles.h2),
          const SizedBox(height: 4),
          Text(race.circuit.circuitName, style: AppStyles.body.copyWith(color: AppTheme.red)),
          const SizedBox(height: 4),
          Text(dateRange, style: AppStyles.body),
          if (CircuitLayoutAssets.hasLayout(race.circuit.circuitId)) ...[
            const SizedBox(height: 12),
            CircuitLayoutImage(circuitId: race.circuit.circuitId, height: 140, padding: EdgeInsets.zero),
          ],
          if (showCountdown) ...[
            const SizedBox(height: 16),
            Text(context.l10n.scheduleCountdownTitle, style: AppStyles.caption.copyWith(color: AppTheme.textGray)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _CountdownCell(value: '${countdown.days}', label: context.l10n.scheduleDays)),
                Expanded(child: _CountdownCell(value: '${countdown.hours}', label: context.l10n.scheduleHours)),
                Expanded(child: _CountdownCell(value: '${countdown.minutes}', label: context.l10n.scheduleMinutes)),
              ],
            ),
          ],
          const SizedBox(height: 16),
          BlackButton(
            onTap: onViewSchedule,
            text: context.l10n.scheduleViewSessions,
            isDisabled: false,
          ),
        ],
      ),
    );
  }
}

class _CountdownCell extends StatelessWidget {
  const _CountdownCell({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: AppStyles.h3),
        const SizedBox(height: 2),
        Text(label, style: AppStyles.caption.copyWith(color: AppTheme.textGray)),
      ],
    );
  }
}
