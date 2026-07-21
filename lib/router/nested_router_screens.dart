import 'package:auto_route/auto_route.dart';

/// Вложенный роутер раздела «Главная».
@RoutePage(name: 'HomeRouter')
class HomeRouterScreen extends AutoRouter {
  const HomeRouterScreen({super.key});
}

/// Вложенный роутер раздела «Результаты».
@RoutePage(name: 'ResultsRouter')
class ResultsRouterScreen extends AutoRouter {
  const ResultsRouterScreen({super.key});
}

/// Вложенный роутер раздела «Расписание».
@RoutePage(name: 'ScheduleRouter')
class ScheduleRouterScreen extends AutoRouter {
  const ScheduleRouterScreen({super.key});
}

/// Вложенный роутер раздела «Новости».
@RoutePage(name: 'NewsRouter')
class NewsRouterScreen extends AutoRouter {
  const NewsRouterScreen({super.key});
}

/// Вложенный роутер раздела «Трассы».
@RoutePage(name: 'CircuitsRouter')
class CircuitsRouterScreen extends AutoRouter {
  const CircuitsRouterScreen({super.key});
}
