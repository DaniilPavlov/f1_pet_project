import 'package:f1_pet_project/data/models/sections/schedule/race_date_model.dart';
import 'package:f1_pet_project/utils/constants/static.dart';
import 'package:f1_pet_project/utils/theme/styles.dart';
import 'package:f1_pet_project/utils/theme/theme.dart';
import 'package:f1_pet_project/utils/utils.dart';
import 'package:flutter/material.dart';

class ScheduleContainer extends StatelessWidget {
  final String title;
  final RaceDateModel date;
  const ScheduleContainer({
    required this.title,
    required this.date,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final parsedDate = DateTime.parse(date.date);
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
                          '${parsedDate.day} ${Utils.getMonthNameByNumber(month: parsedDate.month)} ${parsedDate.year}',
                          style: AppStyles.body,
                        ),
                        // TODO(pavlov): решить какой часовой пояс показывать
                        Text(
                          date.time.replaceAll('Z', ''),
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
