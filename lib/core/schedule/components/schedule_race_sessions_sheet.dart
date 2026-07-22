import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/default_bottom_sheet.dart';
import 'package:f1_pet_project/core/schedule/components/schedule_container.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:flutter/material.dart';

/// Нижний лист с сессиями выбранного ГП.
class ScheduleRaceSessionsSheet extends StatelessWidget {
  const ScheduleRaceSessionsSheet({required this.race, super.key});

  final RacesModel race;

  static Future<void> show(BuildContext context, RacesModel race) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => SizedBox(
        height: MediaQuery.of(context).size.height * 0.65,
        child: ScheduleRaceSessionsSheet(race: race),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final sessions = <(String, RaceDateModel)>[
      if (race.firstPractice != null) (l10n.firstPractice, race.firstPractice!),
      if (race.secondPractice != null) (l10n.secondPractice, race.secondPractice!),
      if (race.thirdPractice != null) (l10n.thirdPractice, race.thirdPractice!),
      if (race.sprintQualifying != null) (l10n.sprintQualifying, race.sprintQualifying!),
      if (race.sprint != null) (l10n.sprint, race.sprint!),
      if (race.qualifying != null) (l10n.qualifying, race.qualifying!),
      (l10n.race, RaceDateModel(date: race.date, time: race.time ?? '')),
    ];

    return DefaultBottomSheet(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(race.raceName, style: AppStyles.h2),
          const SizedBox(height: 4),
          Text(race.circuit.circuitName, style: AppStyles.body),
          const SizedBox(height: StaticData.defaultVerticalPadding),
          Expanded(
            child: ListView.builder(
              itemCount: sessions.length,
              itemBuilder: (context, index) {
                final (title, date) = sessions[index];
                return ScheduleContainer(title: title, date: date);
              },
            ),
          ),
        ],
      ),
    );
  }
}
