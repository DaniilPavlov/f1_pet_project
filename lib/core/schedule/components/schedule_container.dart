import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/helpers/race_datetime_helper.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Карточка сессии с названием и временем в локальном часовом поясе.
class ScheduleContainer extends StatelessWidget {
  const ScheduleContainer({required this.title, required this.date, super.key});
  final String title;
  final RaceDateModel date;

  @override
  Widget build(BuildContext context) {
    final localDate = RaceDateTimeHelper.toLocal(date);

    return Padding(
      padding: const EdgeInsets.only(bottom: StaticData.defaultHorizontalPadding),
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: AppTheme.red),
          borderRadius: const BorderRadius.all(Radius.circular(20)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppStyles.h3),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat.yMMMMd(Localizations.localeOf(context).toLanguageTag()).format(localDate),
                          style: AppStyles.body,
                        ),
                        Text(Utils.formatHourMinute(localDate), style: AppStyles.body),
                        const SizedBox.shrink(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.flag_circle),
          ],
        ),
      ),
    );
  }
}
