import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/models/career/career_race_result.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/default_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/career/career_list_tile.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';

/// Bottom sheet со списком побед или подиумов пилота.
Future<void> showCareerRaceResultsSheet({
  required BuildContext context,
  required String title,
  required List<CareerRaceResult> races,
  required bool showPosition,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: DefaultBottomSheet(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: AppStyles.h2),
            const SizedBox(height: 16),
            Expanded(
              child: races.isEmpty
                  ? Center(child: Text(context.l10n.careerRaceListEmpty, style: AppStyles.body))
                  : ListView.separated(
                      itemCount: races.length,
                      separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.strokeGray),
                      itemBuilder: (context, index) {
                        final race = races[index];
                        final subtitle = showPosition
                            ? 'P${race.position} · ${race.entityName}'
                            : race.entityName;
                        return CareerListTile(
                          title: '${race.season} · ${race.raceName}',
                          subtitle: subtitle,
                          onTap: () {
                            Navigator.of(context).pop();
                            context.router.push(CircuitRoute(circuitModel: race.circuit));
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    ),
  );
}
