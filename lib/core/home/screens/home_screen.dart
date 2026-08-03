import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/platform_capabilities.dart';
import 'package:f1_pet_project/common/utils/theme/anti_glow_behavior.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/app_bar/custom_app_bar.dart';
import 'package:f1_pet_project/common/widgets/cached_data_banner.dart';
import 'package:f1_pet_project/common/widgets/error_body.dart';
import 'package:f1_pet_project/common/widgets/on_app_resumed.dart';
import 'package:f1_pet_project/common/widgets/shimmer/tournament_tables_shimmer.dart';
import 'package:f1_pet_project/common/widgets/tables/tournament_tables_section.dart';
import 'package:f1_pet_project/core/home/components/home_headlines_section.dart';
import 'package:f1_pet_project/core/home/controllers/home_screen_controller/home_screen_controller.dart';
import 'package:f1_pet_project/core/home/repositories/current_standings_repository.dart';
import 'package:f1_pet_project/core/news/controllers/news_screen_controller/news_screen_controller.dart';
import 'package:f1_pet_project/core/news/repositories/news_repository.dart';
import 'package:f1_pet_project/services/app_data_refresh.dart';
import 'package:f1_pet_project/services/home_widget/app_widget_sync_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

/// Главный экран: турнирные таблицы + заголовки новостей.
@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Provider<HomeScreenController>(
      create: (context) {
        final controller = HomeScreenController(
          standingsRepository: context.read<CurrentStandingsRepository>(),
          dataRefresh: context.read<AppDataRefresh>(),
        );
        final widgets = PlatformCapabilities.hasHomeWidgets ? context.read<AppWidgetSyncService>() : null;
        unawaited(controller.loadAllData().then((_) => widgets?.sync()));
        return controller;
      },
      child: Provider<NewsScreenController>(
        create: (context) => NewsScreenController(
          newsRepository: context.read<NewsRepository>(),
          dataRefresh: context.read<AppDataRefresh>(),
        )..loadArticles(),
        child: const _HomeView(),
      ),
    );
  }
}

class _HomeView extends StatefulWidget {
  const _HomeView();

  @override
  State<_HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<_HomeView> {
  /// Запас после ухода заголовка «Новости», прежде чем показать FAB.
  static const _fabExtraOffset = 500.0;

  final _scrollController = ScrollController();
  final _newsTitleKey = GlobalKey();

  var _showScrollToNews = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  void _handleScroll() {
    _updateFabVisibility();
  }

  void _updateFabVisibility() {
    final show = _shouldShowScrollToNewsFab();
    if (show == _showScrollToNews) {
      return;
    }
    setState(() => _showScrollToNews = show);
  }

  /// FAB виден, когда заголовок ушёл выше viewport ещё на [_fabExtraOffset].
  bool _shouldShowScrollToNewsFab() {
    final titleContext = _newsTitleKey.currentContext;
    if (titleContext == null || !_scrollController.hasClients) {
      return false;
    }

    final titleBox = titleContext.findRenderObject();
    if (titleBox is! RenderBox || !titleBox.hasSize) {
      return false;
    }

    final scrollContext = _scrollController.position.context.notificationContext;
    final scrollBox = scrollContext?.findRenderObject();
    if (scrollBox is! RenderBox || !scrollBox.hasSize) {
      return false;
    }

    final titleBottom = titleBox.localToGlobal(Offset(0, titleBox.size.height)).dy;
    final viewportTop = scrollBox.localToGlobal(Offset.zero).dy;
    // titleBottom < viewportTop → заголовок уже выше экрана;
    // разница viewportTop - titleBottom — сколько px «проскроллили мимо».
    return viewportTop - titleBottom >= _fabExtraOffset;
  }

  Future<void> _scrollToNewsTitle() async {
    final titleContext = _newsTitleKey.currentContext;
    if (titleContext == null) {
      return;
    }
    await Scrollable.ensureVisible(
      titleContext,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutCubic,
      alignment: 0,
    );
    if (mounted) {
      _updateFabVisibility();
    }
  }

  Future<void> _refresh(HomeScreenController controller) async {
    final news = context.read<NewsScreenController>();
    await Future.wait([controller.refreshAll(), news.refreshAll()]);
    if (PlatformCapabilities.hasHomeWidgets && mounted) {
      await context.read<AppWidgetSyncService>().sync();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      floatingActionButton: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        switchInCurve: Curves.easeOut,
        switchOutCurve: Curves.easeIn,
        transitionBuilder: (child, animation) => ScaleTransition(scale: animation, child: child),
        child: _showScrollToNews
            ? FloatingActionButton.small(
                key: const ValueKey('home-scroll-to-news'),
                tooltip: context.l10n.homeScrollToNews,
                onPressed: _scrollToNewsTitle,
                child: const Icon(Icons.keyboard_arrow_up_rounded),
              )
            : const SizedBox.shrink(key: ValueKey('home-scroll-to-news-hidden')),
      ),
      body: SafeArea(
        child: OnAppResumed(
          onResumed: () {
            final controller = context.read<HomeScreenController>();
            unawaited(controller.dismissOfflineBannerIfOnline());
          },
          child: Observer(
          builder: (context) {
            final controller = context.read<HomeScreenController>();
            final hasData = controller.currentDrivers.value != null && controller.currentConstructors.value != null;
            if (!hasData && (controller.currentDrivers.isLoading || controller.currentConstructors.isLoading)) {
              return const SingleChildScrollView(child: TournamentTablesShimmer());
            }
            if (controller.screenError != null && !hasData) {
              return ErrorBody(
                onTap: () => _refresh(controller),
                title: controller.screenError!.title,
                subtitle: controller.screenError!.subtitle,
              );
            }

            return RefreshIndicator(
              color: AppTheme.red,
              onRefresh: () => _refresh(controller),
              child: NotificationListener<ScrollNotification>(
                onNotification: (notification) {
                  if (notification.metrics.extentAfter < 480) {
                    context.read<NewsScreenController>().revealMore();
                  }
                  return false;
                },
                child: CustomScrollView(
                  controller: _scrollController,
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollBehavior: AntiGlowBehavior(),
                  slivers: [
                    if (controller.showingCachedData)
                      SliverToBoxAdapter(
                        child: CachedDataBanner(message: context.l10n.showingCachedData),
                      ),
                    SliverToBoxAdapter(
                      child: TournamentTablesSection(
                        driversStandings: controller.currentDrivers.value!,
                        constructorsStandings: controller.currentConstructors.value!,
                        title: context.l10n.homeStandingsTitle,
                        season: controller.currentSeason,
                        round: controller.currentRound,
                        passCurrentRoster: true,
                      ),
                    ),
                    SliverToBoxAdapter(child: HomeHeadlinesSection(titleKey: _newsTitleKey)),
                  ],
                ),
              ),
            );
          },
        ),
        ),
      ),
    );
  }
}
