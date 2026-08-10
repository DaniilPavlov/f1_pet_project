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
import 'package:f1_pet_project/core/circuits/providers.dart';
import 'package:f1_pet_project/core/circuits/state/state_models/circuits_page_view_model.dart';
import 'package:f1_pet_project/core/circuits/view/widgets/circuits_list.dart';
import 'package:f1_pet_project/core/circuits/view/widgets/circuits_map_stub.dart'
    if (dart.library.io) 'package:f1_pet_project/core/circuits/view/widgets/circuits_map.dart';
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
    Future.microtask(() => ref.read(circuitsPageManagerProvider).loadCircuits());
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(circuitsPageStateHolderProvider);
    final manager = ref.watch(circuitsPageManagerProvider);

    return Scaffold(
      appBar: CustomAppBar(
        title: context.l10n.navCircuits,
        onPop: () => context.router.maybePop(),
      ),
      body: SafeArea(
        child: OnAppResumed(
          onResumed: () {
            unawaited(manager.dismissOfflineBannerIfOnline());
          },
          child: Builder(
            builder: (context) {
              return switch (viewModel) {
                CircuitsPageLoading() => const CustomLoadingIndicator(),
                CircuitsPageError(:final exception) => ErrorBody(
                    onTap: manager.refreshAll,
                    title: exception.title,
                    subtitle: exception.subtitle,
                  ),
                CircuitsPageSuccess(
                  :final circuits,
                  :final activePage,
                  :final showingCachedData,
                ) =>
                  !PlatformCapabilities.hasYandexMap
                      ? Column(
                          children: [
                            if (showingCachedData) CachedDataBanner(message: context.l10n.showingCachedData),
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
                                onRefresh: manager.refreshAll,
                                child: CircuitsList(circuits: circuits),
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            if (showingCachedData) CachedDataBanner(message: context.l10n.showingCachedData),
                            const SizedBox(height: 12),
                            CustomSwitcher(
                              firstTitle: context.l10n.onMap,
                              secondTitle: context.l10n.asList,
                              onChanged: manager.changeActivePage,
                              activeValue: activePage,
                            ),
                            Expanded(
                              child: PageView(
                                onPageChanged: manager.changeActivePage,
                                controller: manager.pageController,
                                children: [
                                  CircuitsMap(circuits: circuits),
                                  RefreshIndicator(
                                    color: AppTheme.red,
                                    onRefresh: manager.refreshAll,
                                    child: CircuitsList(circuits: circuits),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
              };
            },
          ),
        ),
      ),
    );
  }
}
