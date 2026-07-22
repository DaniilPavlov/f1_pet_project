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
  String get navNews => 'News';

  @override
  String get navCircuits => 'Circuits';

  @override
  String get newsTitle => 'News';

  @override
  String get newsEmpty => 'No news right now';

  @override
  String get homeStandingsTitle => 'Current season standings';

  @override
  String get circuitStatLength => 'Length';

  @override
  String get circuitStatLaps => 'Laps';

  @override
  String get circuitStatTurns => 'Turns';

  @override
  String get circuitStatTopSpeed => 'Speed';

  @override
  String get circuitStatElevation => 'Elevation';

  @override
  String get homeWeekendTitle => 'Race weekend';

  @override
  String get homeWeekendLive => 'Live';

  @override
  String homeWeekendLeader(String name) {
    return 'Leader: $name';
  }

  @override
  String homeWeekendWinner(String name) {
    return 'Winner: $name';
  }

  @override
  String weekendSessionResultsTitle(String session) {
    return 'Results: $session';
  }

  @override
  String get weekendSessionResultsEmpty => 'No results yet';

  @override
  String get driverNotFound => 'Driver not found';

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
  String get timeStatus => 'Time /\nStatus';

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
  String get chooseSpecificRace => 'Choose a specific race';

  @override
  String get raceSearchTitle => 'Race search';

  @override
  String get season => 'Season';

  @override
  String get yearHint => 'Year';

  @override
  String get selectSeason => 'Select season';

  @override
  String get selectRace => 'Select race';

  @override
  String get selectSeasonFirst => 'Select a season first';

  @override
  String get seasonsLoadError => 'Could not load seasons';

  @override
  String get racesLoadError => 'Could not load races';

  @override
  String get round => 'Round';

  @override
  String get numberHint => 'Number';

  @override
  String get search => 'Search';

  @override
  String get raceSearchInfo => 'Pick a season, then a race from the list.';

  @override
  String get raceNotFound =>
      'No races found for your query. Check the entered data and try again.';

  @override
  String get hallOfFameTitle => 'Hall of Fame';

  @override
  String get h2hTitle => 'H2H · Drivers';

  @override
  String get h2hSubtitle =>
      'Compare two drivers with filters for period and driver list';

  @override
  String get h2hDriverA => 'Driver 1';

  @override
  String get h2hDriverB => 'Driver 2';

  @override
  String get h2hCompare => 'Compare';

  @override
  String get h2hFiltersTitle => 'Filters';

  @override
  String get h2hPeriodFilter => 'Period';

  @override
  String get h2hSeasonFilter => 'Season';

  @override
  String get h2hCurrentSeason => 'Current';

  @override
  String get h2hPickYear => 'Pick year';

  @override
  String get h2hDriversFilter => 'Drivers';

  @override
  String get h2hCurrentDrivers => 'Current';

  @override
  String get h2hAllDrivers => 'All';

  @override
  String get h2hSearchDriver => 'Name or code';

  @override
  String get h2hDriversEmpty => 'No drivers found';

  @override
  String get h2hConstructorsTitle => 'H2H · Constructors';

  @override
  String get h2hConstructorsSubtitle =>
      'Compare two constructors with filters for period and constructor list';

  @override
  String get h2hConstructorA => 'Constructor 1';

  @override
  String get h2hConstructorB => 'Constructor 2';

  @override
  String get h2hConstructorsFilter => 'Constructors';

  @override
  String get h2hCurrentConstructors => 'Current';

  @override
  String get h2hAllConstructors => 'All';

  @override
  String get h2hSearchConstructor => 'Name';

  @override
  String get h2hConstructorsEmpty => 'No constructors found';

  @override
  String get selectConstructor => 'Select a constructor';

  @override
  String get constructorsLoadError => 'Could not load constructors';

  @override
  String get finishStatusTitle => 'Finish statuses';

  @override
  String get finishStatusSubtitle =>
      'How drivers finished races this season — Finished, Retired, DSQ, +laps, and more.';

  @override
  String get finishStatusEmpty => 'No finish statuses for this season';

  @override
  String get shareNoResults => 'No race results yet';

  @override
  String shareAndMore(int count) {
    return '…and $count more';
  }

  @override
  String get selectDriver => 'Select a driver';

  @override
  String get driversLoadError => 'Could not load drivers';

  @override
  String get onMap => 'On map';

  @override
  String get asList => 'List';

  @override
  String get circuitsMapWebUnavailable =>
      'Map is available in the mobile app. Browse circuits as a list below.';

  @override
  String get circuitDetails => 'Circuit details';

  @override
  String get circuitInfoTitle => 'Circuit information';

  @override
  String get circuitWinnersTitle => 'Winners';

  @override
  String get circuitWinnersEmpty => 'No race winners for this circuit yet';

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
  String scheduleRound(String round) {
    return 'Round $round';
  }

  @override
  String get scheduleCountdownTitle => 'FP1 starts in';

  @override
  String get scheduleDays => 'Days';

  @override
  String get scheduleHours => 'Hours';

  @override
  String get scheduleMinutes => 'Minutes';

  @override
  String get scheduleViewSessions => 'View schedule';

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
  String get unknown => 'Unknown';

  @override
  String get currentTeam => 'Current team';

  @override
  String get currentDrivers => 'Current drivers';

  @override
  String get careerTitle => 'Career';

  @override
  String get driverNewsTitle => 'Latest news';

  @override
  String get careerStatRaces => 'Races';

  @override
  String get careerStatPodiums => 'Podiums';

  @override
  String get careerStatPoles => 'Poles';

  @override
  String get careerRaceListEmpty => 'No races in this list';

  @override
  String get driverTeamsTitle => 'Teams';

  @override
  String get constructorDriversTitle => 'Drivers';

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
  String get tooManyRequestsSubtitle =>
      'The API is rate-limiting requests. Wait a moment and try again.';

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
