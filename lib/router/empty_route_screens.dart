import 'package:auto_route/auto_route.dart';

class EmptyRouteScreens {}

@RoutePage(name: 'HomeRouter')
class HomeRouterScreen extends AutoRouter {
  const HomeRouterScreen({super.key});
}

@RoutePage(name: 'ResultsRouter')
class ResultsRouterScreen extends AutoRouter {
  const ResultsRouterScreen({super.key});
}

@RoutePage(name: 'ScheduleRouter')
class ScheduleRouterScreen extends AutoRouter {
  const ScheduleRouterScreen({super.key});
}

@RoutePage(name: 'HallOfFameRouter')
class HallOfFameRouterScreen extends AutoRouter {
  const HallOfFameRouterScreen({super.key});
}

@RoutePage(name: 'CircuitsRouter')
class CircuitsRouterScreen extends AutoRouter {
  const CircuitsRouterScreen({super.key});
}
