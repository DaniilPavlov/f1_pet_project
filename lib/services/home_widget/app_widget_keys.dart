/// Keys shared with Android AppWidget / iOS WidgetKit.
abstract final class AppWidgetKeys {
  static const prefsName = 'f1_app_widgets';
  static const iosAppGroup = 'group.com.example.f1PetProject';

  static const nextGpRaceName = 'next_gp_race_name';
  static const nextGpCircuit = 'next_gp_circuit';
  static const nextGpTargetMs = 'next_gp_target_ms';
  static const nextGpHasData = 'next_gp_has_data';

  static const standingsSeason = 'standings_season';
  static const standingsRound = 'standings_round';
  static const standingsHasData = 'standings_has_data';

  /// `standings_d{i}_code` / `standings_d{i}_points` for i in 1..3.
  static String driverCode(int index) => 'standings_d${index}_code';
  static String driverPoints(int index) => 'standings_d${index}_points';

  /// Android AppWidgetProvider class names / iOS WidgetKit kinds (mapped natively).
  static const nextGpProvider = 'NextGpWidgetProvider';
  static const standingsProvider = 'StandingsWidgetProvider';
}
