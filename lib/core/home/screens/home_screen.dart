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
import 'package:f1_pet_project/core/news/controllers/news_screen_controller/news_screen_controller.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Главный экран: турнирные таблицы + заголовки новостей.
@RoutePage()
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  /// Запас после ухода заголовка «Новости», прежде чем показать FAB.
  static const _fabExtraOffset = 500.0;

  final _scrollController = ScrollController();
  final _newsTitleKey = GlobalKey();

  var _showScrollToNews = false;
  var _initialLoadStarted = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialLoadStarted) {
      return;
    }
    _initialLoadStarted = true;
    final widgets = PlatformCapabilities.hasHomeWidgets ? ref.read(appWidgetSyncServiceProvider) : null;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      unawaited(
        ref.read(homeScreenControllerProvider.notifier).loadAllData().then((_) => widgets?.sync()),
      );
      unawaited(ref.read(newsScreenControllerProvider.notifier).loadArticles());
    });
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

  Future<void> _refresh() async {
    await Future.wait([
      ref.read(homeScreenControllerProvider.notifier).refreshAll(),
      ref.read(newsScreenControllerProvider.notifier).refreshAll(),
    ]);
    if (PlatformCapabilities.hasHomeWidgets && mounted) {
      await ref.read(appWidgetSyncServiceProvider).sync();
    }
  }

  @override
  Widget build(BuildContext context) {
    final home = ref.watch(homeScreenControllerProvider);
    // Держим autoDispose-провайдер новостей живым, пока открыт Home
    // (иначе loadArticles из post-frame dispose'ится до появления секции).
    ref.watch(newsScreenControllerProvider);
    final hasData = home.currentDrivers.value != null && home.currentConstructors.value != null;

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
            unawaited(ref.read(homeScreenControllerProvider.notifier).dismissOfflineBannerIfOnline());
          },
          child: _buildBody(context, home: home, hasData: hasData),
        ),
      ),
    );
  }

  Widget _buildBody(BuildContext context, {required HomeState home, required bool hasData}) {
    if (!hasData && (home.currentDrivers.isLoading || home.currentConstructors.isLoading)) {
      return const SingleChildScrollView(child: TournamentTablesShimmer());
    }
    if (home.screenError != null && !hasData) {
      return ErrorBody(
        onTap: _refresh,
        title: home.screenError!.title,
        subtitle: home.screenError!.subtitle,
      );
    }

    return RefreshIndicator(
      color: AppTheme.red,
      onRefresh: _refresh,
      child: NotificationListener<ScrollNotification>(
        onNotification: (notification) {
          if (notification.metrics.extentAfter < 480) {
            ref.read(newsScreenControllerProvider.notifier).revealMore();
          }
          return false;
        },
        child: CustomScrollView(
          controller: _scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          scrollBehavior: AntiGlowBehavior(),
          slivers: [
            if (home.showingCachedData)
              SliverToBoxAdapter(
                child: CachedDataBanner(message: context.l10n.showingCachedData),
              ),
            SliverToBoxAdapter(
              child: TournamentTablesSection(
                driversStandings: home.currentDrivers.value!,
                constructorsStandings: home.currentConstructors.value!,
                title: context.l10n.homeStandingsTitle,
                season: home.currentSeason,
                round: home.currentRound,
                passCurrentRoster: true,
              ),
            ),
            SliverToBoxAdapter(child: HomeHeadlinesSection(titleKey: _newsTitleKey)),
          ],
        ),
      ),
    );
  }
}
