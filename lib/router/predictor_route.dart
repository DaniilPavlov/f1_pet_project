import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';

/// Маршрут вкладки «Предиктор».
final AutoRoute predictorRoute = AutoRoute(
  path: 'predictor',
  page: PredictorRouter.page,
  children: [
    AutoRoute(path: '', page: PredictorRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(
      path: 'season',
      page: PredictorSeasonHistoryRoute.page,
      meta: const <String, bool>{'hideBottomNav': false},
    ),
    AutoRoute(
      path: 'weekend',
      page: PredictorWeekendDetailRoute.page,
      meta: const <String, bool>{'hideBottomNav': false},
    ),
    AutoRoute(
      path: 'leaderboard',
      page: PredictorLeaderboardRoute.page,
      meta: const <String, bool>{'hideBottomNav': false},
    ),
  ],
);
