import 'package:f1_pet_project/data/models/sections/schedule/race_date_model.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:f1_pet_project/utils/utils.dart';
import 'package:flutter/material.dart';

class ScheduleContainer extends StatelessWidget {
  const ScheduleContainer({
    required this.title,
    required this.date,
    super.key,
  });
  final String title;
  final RaceDateModel date;

  @override
  Widget build(BuildContext context) {
    // перевожу время из гринвича в локальное
    final parsedTime = date.time.split(':');
    final greenwichDate = DateTime.parse(date.date).add(
      Duration(
        hours: int.parse(parsedTime[0]),
        minutes: int.parse(parsedTime[1]),
      ),
    );

    final deviceOffset = DateTime.now().timeZoneOffset.toString().split(':');
    final dateWithOffset =
        greenwichDate.add(Duration(hours: int.parse(deviceOffset[0])));

    return Padding(
      padding:
          const EdgeInsets.only(bottom: StaticData.defaultHorizontalPadding),
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
                          '${dateWithOffset.day} ${Utils.getMonthNameByNumber(month: dateWithOffset.month)} ${dateWithOffset.year}',
                          style: AppStyles.body,
                        ),
                        Text(
                          Utils.formatHourMinute(dateWithOffset),
                          style: AppStyles.body,
                        ),
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
