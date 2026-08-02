import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';

/// Маршрут вкладки «Профиль» (+ auth).
///
/// `hideBottomNav: true` на sign-in/register — читает [ScaffoldWithNavBarScreen].
final AutoRoute profileRoute = AutoRoute(
  path: 'profile',
  page: ProfileRouter.page,
  children: [
    AutoRoute(path: '', page: ProfileRoute.page, meta: const <String, bool>{'hideBottomNav': false}),
    AutoRoute(path: 'sign-in', page: AuthSignInRoute.page, meta: const <String, bool>{'hideBottomNav': true}),
    AutoRoute(path: 'register', page: AuthRegisterRoute.page, meta: const <String, bool>{'hideBottomNav': true}),
  ],
);
