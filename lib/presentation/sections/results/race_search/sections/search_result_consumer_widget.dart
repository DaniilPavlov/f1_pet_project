import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:f1_pet_project/presentation/sections/results/widgets/race_info_table.dart';
import 'package:f1_pet_project/providers/results/race_search/race_search_providers.dart';
import 'package:f1_pet_project/utils/constants/static_data.dart';
import 'package:f1_pet_project/utils/theme/app_styles.dart';
import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchResultConsumerWidget extends ConsumerWidget {
  final RacesModel? result;
  final String? error;
  const SearchResultConsumerWidget({this.result, this.error, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (result != null) ...[
          Padding(
            padding: const EdgeInsets.only(
              left: StaticData.defaultHorizontalPadding,
              right: StaticData.defaultHorizontalPadding,
              top: StaticData.defaultVerticallPadding * 2,
            ),
            child: Text(
              result!.raceName,
              style: AppStyles.h2,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: StaticData.defaultVerticallPadding,
            ),
            child: RaceInfoTable(
              fastestLap: ref.read(raceSearchFastestLapProvider),
              rowsNumber: 3,
              raceModel: result!,
            ),
          ),
        ],
        if (error != null)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: StaticData.defaultVerticallPadding,
              horizontal: StaticData.defaultHorizontalPadding,
            ),
            child: Text(
              error!,
              style: AppStyles.body.copyWith(color: AppTheme.red),
            ),
          )
        else
          const SizedBox.shrink(),

        // TODO(pavlov): вернуть потом
        // StateNotifierBuilder<String>(
        //   listenableState: wm.errorMessage,
        //   builder: (_, errorMessage) => wm.errorMessage.value!.isNotEmpty
        //       ? Padding(
        //           padding: const EdgeInsets.symmetric(
        //             vertical: StaticData.defaultVerticallPadding,
        //             horizontal: StaticData.defaultHorizontalPadding,
        //           ),
        //           child: Text(
        //             wm.errorMessage.value!,
        //             style: AppStyles.body.copyWith(color: AppTheme.red),
        //           ),
        //         )
        //       : const SizedBox.shrink(),
        // ),
      ],
    );
  }
}
