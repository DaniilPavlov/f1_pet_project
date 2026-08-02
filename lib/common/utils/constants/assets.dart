/// Пути к локальным ассетам (как `Assets.*` в b2c, без flutter_gen из‑за конфликтов deps).
abstract final class Assets {
  static const navBar = NavBarAssets();
  static const icons = IconsAssets();
  static const calendar = CalendarAssets();
  static const appLogo = 'assets/app_logo.png';
  static const errorCar = 'assets/error_car.png';
}

/// Иконки нижней навигации: `assets/nav_bar/`.
final class NavBarAssets {
  const NavBarAssets();

  String get home => 'assets/nav_bar/home.png';
  String get racingCar => 'assets/nav_bar/racing-car.png';
  String get lights => 'assets/nav_bar/lights.png';
  String get trophy => 'assets/nav_bar/trophy.png';
  String get circuit => 'assets/nav_bar/circuit.png';
  String get helmet => 'assets/nav_bar/helmet.png';
}

/// Иконки карты и UI: `assets/icons/`.
final class IconsAssets {
  const IconsAssets();

  String get pinUnselected => 'assets/icons/pin_unselected.png';
  String get pinRed => 'assets/icons/pin_red.png';
  String get locationUser => 'assets/icons/location_user.png';
}

/// Иконки календаря: `assets/calendar/`.
final class CalendarAssets {
  const CalendarAssets();

  String get finish => 'assets/calendar/finish.png';
  String get car => 'assets/calendar/car.png';
}
