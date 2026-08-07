import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/platform_capabilities.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/cached_data_banner.dart';
import 'package:f1_pet_project/common/widgets/custom_loading_indicator.dart';
import 'package:f1_pet_project/common/widgets/custom_switcher.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/on_app_resumed.dart';
import 'package:f1_pet_project/core/circuits/components/circuits_list.dart';
import 'package:f1_pet_project/core/circuits/components/circuits_map_stub.dart'
    if (dart.library.io) 'package:f1_pet_project/core/circuits/components/circuits_map.dart';
import 'package:f1_pet_project/core/circuits/controllers/circuits_screen_controller/circuits_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Экран списка трасс с переключением между картой и списком (на web — только список).
///
/// GoF Structural Bridge — абстракция `CircuitsMap` отделена от платформы:
/// stub на web и MapKit на IO через conditional import.
@RoutePage()
class CircuitsScreen extends ConsumerStatefulWidget {
  const CircuitsScreen({super.key});

  @override
  ConsumerState<CircuitsScreen> createState() => _CircuitsScreenState();
}

class _CircuitsScreenState extends ConsumerState<CircuitsScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(circuitsScreenControllerProvider.notifier).loadCircuits());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(circuitsScreenControllerProvider);
    final controller = ref.read(circuitsScreenControllerProvider.notifier);

    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.navCircuits,
        onPop: () => context.router.maybePop(),
      ),
      body: SafeArea(
        child: OnAppResumed(
          onResumed: () {
            unawaited(controller.dismissOfflineBannerIfOnline());
          },
          child: Builder(
            builder: (context) {
              if (state.circuits.isLoading) {
                return const CustomLoadingIndicator();
              }
              if (state.circuits.isError) {
                return ErrorBody(
                  onTap: controller.refreshAll,
                  title: state.screenError!.title,
                  subtitle: state.screenError!.subtitle,
                );
              }

              final circuits = state.circuits.value ?? [];

              if (!PlatformCapabilities.hasYandexMap) {
                return Column(
                  children: [
                    if (state.showingCachedData) CachedDataBanner(message: context.l10n.showingCachedData),
                    const SizedBox(height: 12),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        context.l10n.circuitsMapWebUnavailable,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: RefreshIndicator(
                        color: AppTheme.red,
                        onRefresh: controller.refreshAll,
                        child: CircuitsList(circuits: circuits),
                      ),
                    ),
                  ],
                );
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (state.showingCachedData) CachedDataBanner(message: context.l10n.showingCachedData),
                  const SizedBox(height: 12),
                  CustomSwitcher(
                    firstTitle: context.l10n.onMap,
                    secondTitle: context.l10n.asList,
                    onChanged: controller.changeActivePage,
                    activeValue: state.activePage,
                  ),
                  Expanded(
                    child: PageView(
                      onPageChanged: controller.changeActivePage,
                      controller: controller.pageController,
                      children: [
                        CircuitsMap(circuits: circuits),
                        RefreshIndicator(
                          color: AppTheme.red,
                          onRefresh: controller.refreshAll,
                          child: CircuitsList(circuits: circuits),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
