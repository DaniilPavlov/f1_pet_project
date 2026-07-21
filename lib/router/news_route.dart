import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';

/// Маршрут вкладки «Новости».
final AutoRoute newsRoute = AutoRoute(
  path: 'news',
  page: NewsRouter.page,
  children: [
    AutoRoute(path: '', page: NewsRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
  ],
);
