import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/helpers/share_helper.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/shimmer/race_section_shimmer.dart';
import 'package:f1_pet_project/core/results/race_info/components/race_info_scroll_body.dart';
import 'package:f1_pet_project/core/results/race_info/providers.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Детальный экран гонки: результаты, спринт, квалификация и пит-стопы.
@RoutePage()
class RaceInfoScreen extends ConsumerStatefulWidget {
  const RaceInfoScreen({required this.raceModel, super.key});

  final RacesModel raceModel;

  @override
  ConsumerState<RaceInfoScreen> createState() => _RaceInfoScreenState();
}

class _RaceInfoScreenState extends ConsumerState<RaceInfoScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(analyticsGatewayProvider).log(
            RaceOpened(
              raceName: widget.raceModel.raceName,
              season: widget.raceModel.season,
              round: widget.raceModel.round,
            ),
          );
      return ref.read(raceInfoPageManagerProvider(widget.raceModel)).loadAllData();
    });
  }

  @override
  Widget build(BuildContext context) {
    final raceModel = widget.raceModel;
    final viewModel = ref.watch(raceInfoPageStateHolderProvider(raceModel));
    final manager = ref.watch(raceInfoPageManagerProvider(raceModel));
    final canShare = viewModel.allDataIsLoaded && viewModel.screenError == null;

    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.detailedInfo,
        showPreferences: false,
        onPop: () => context.router.maybePop(),
        onShare: canShare
            ? () => ShareHelper.shareRaceResultsCard(
                context: context,
                l10n: context.l10n,
                race: raceModel,
              )
            : null,
      ),
      body: SafeArea(
        child: viewModel.screenError != null
            ? ErrorBody(
                onTap: manager.refreshAll,
                title: viewModel.screenError!.title,
                subtitle: viewModel.screenError!.subtitle,
              )
            : !viewModel.allDataIsLoaded
            ? const RaceInfoShimmer()
            : RaceInfoScrollBody(
                raceModel: raceModel,
                viewModel: viewModel,
                onRefresh: manager.refreshAll,
              ),
      ),
    );
  }
}
