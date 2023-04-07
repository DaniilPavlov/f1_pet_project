import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:qlevar_router/qlevar_router.dart';

class HomeRoutes {
  QRoute routes() => QRoute(
        name: 'Home',
        path: 'home',
        builder: () => const HomeScreen(),
      );
}
