// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get navHome => 'Home';

  @override
  String get navResults => 'Results';

  @override
  String get navCalendar => 'Calendar';

  @override
  String get navHallOfFame => 'Hall of Fame';

  @override
  String get navCircuits => 'Circuits';

  @override
  String get homeStandingsTitle => 'Current season standings';

  @override
  String seasonLabel(String season) {
    return 'Season: $season';
  }

  @override
  String roundLabel(String round) {
    return 'Round: $round';
  }

  @override
  String get drivers => 'Drivers';

  @override
  String get constructors => 'Constructors';

  @override
  String get driver => 'Driver';

  @override
  String get constructor => 'Constructor';

  @override
  String get nationality => 'Nationality';

  @override
  String get points => 'Points';

  @override
  String get wins => 'Wins';

  @override
  String get winsShort => 'W';

  @override
  String get country => 'Country';

  @override
  String get time => 'Time';

  @override
  String get bestLap => 'Best\nlap';

  @override
  String get none => 'n/a';

  @override
  String fastestLapLabel(String time) {
    return '$time\nfastest\nlap';
  }

  @override
  String get detailedInfo => 'Detailed information';

  @override
  String get race => 'Race';

  @override
  String get sprint => 'Sprint';

  @override
  String get qualifying => 'Qualifying';

  @override
  String get pitStops => 'Pit stops';

  @override
  String get lap => 'Lap';

  @override
  String get stopNumber => 'Stop\nnumber';

  @override
  String get stopTime => 'Stop\ntime';

  @override
  String get raceTime => 'Race\ntime';

  @override
  String get lastRace => 'Last race: ';

  @override
  String get chooseSpecificRace => 'Choose a specific race';

  @override
  String get raceSearchTitle => 'Race search';

  @override
  String get season => 'Season';

  @override
  String get yearHint => 'Year';

  @override
  String get round => 'Round';

  @override
  String get numberHint => 'Number';

  @override
  String get search => 'Search';

  @override
  String get raceSearchInfo =>
      'Here you can find results of a specific race starting from 1950.\nMinimum rounds per season — 7, maximum — 24.\n(data as of 2026)';

  @override
  String get raceNotFound =>
      'No races found for your query. Check the entered data and try again.';

  @override
  String get hallOfFameTitle => 'Hall of Fame';

  @override
  String get onMap => 'On map';

  @override
  String get asList => 'List';

  @override
  String get circuitDetails => 'Circuit details';

  @override
  String get circuitInfoTitle => 'Circuit information';

  @override
  String get readOnWikipedia => 'Read on Wikipedia';

  @override
  String countryLabel(String country) {
    return 'Country: $country';
  }

  @override
  String cityLabel(String city) {
    return 'City: $city';
  }

  @override
  String get firstPractice => 'First practice';

  @override
  String get secondPractice => 'Second practice';

  @override
  String get thirdPractice => 'Third practice';

  @override
  String get sprintQualifying => 'Sprint qualifying';

  @override
  String get driverCode => 'Code';

  @override
  String get driverNumber => 'Number';

  @override
  String get dateOfBirth => 'Date of birth';

  @override
  String get openInWikipedia => 'Open on Wikipedia';

  @override
  String get driverCareerTitle => 'Career';

  @override
  String get driverTeamsTitle => 'Teams';

  @override
  String get driverStatRaces => 'Races';

  @override
  String get driverStatPodiums => 'Podiums';

  @override
  String get driverStatPoles => 'Poles';

  @override
  String get noConnection => 'No connection';

  @override
  String get noConnectionSubtitle =>
      'Once the connection is restored, you will be able to use the app again';

  @override
  String get refresh => 'Refresh';

  @override
  String get notNow => 'not now';

  @override
  String get settings => 'Settings';

  @override
  String get locationPermissionNeeded =>
      'The app needs access to your location.';

  @override
  String get tooManyRequests => 'Too many requests';

  @override
  String get requestError => 'Error sending the request';

  @override
  String get responseParseError => 'Error processing the server response';

  @override
  String get unexpectedError => 'Unexpected error';

  @override
  String openUrlFailed(String url) {
    return 'Could not open link $url';
  }

  @override
  String get localeCodeRu => 'RU';

  @override
  String get localeCodeEn => 'EN';
}
