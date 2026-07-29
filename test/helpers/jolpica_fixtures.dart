/// Minimal Jolpica-shaped JSON for unit tests.
abstract final class JolpicaFixtures {
  static const driverJson = {
    'driverId': 'max_verstappen',
    'url': 'http://example.com/max',
    'givenName': 'Max',
    'familyName': 'Verstappen',
    'dateOfBirth': '1997-09-30',
    'nationality': 'Dutch',
    'code': 'VER',
    'permanentNumber': '1',
  };

  static const constructorJson = {
    'constructorId': 'red_bull',
    'url': 'http://example.com/red_bull',
    'name': 'Red Bull',
    'nationality': 'Austrian',
  };

  static const circuitJson = {
    'circuitId': 'monaco',
    'url': 'http://example.com/monaco',
    'circuitName': 'Monaco',
    'Location': {'lat': '43.7347', 'long': '7.4206', 'locality': 'Monte Carlo', 'country': 'Monaco'},
  };

  static Map<String, dynamic> resultEntry({
    String position = '1',
    String points = '25',
    Map<String, dynamic>? driver,
    Map<String, dynamic>? constructor,
  }) => {
    'number': '1',
    'position': position,
    'positionText': position,
    'points': points,
    'Driver': driver ?? driverJson,
    'Constructor': constructor ?? constructorJson,
    'grid': '1',
    'laps': '78',
    'status': 'Finished',
  };

  static Map<String, dynamic> race({
    String season = '2024',
    String round = '1',
    String raceName = 'Bahrain Grand Prix',
    List<Map<String, dynamic>>? results,
    List<Map<String, dynamic>>? sprintResults,
    List<Map<String, dynamic>>? qualifyingResults,
  }) => {
    'season': season,
    'round': round,
    'url': 'http://example.com/race',
    'raceName': raceName,
    'Circuit': circuitJson,
    'date': '2024-03-02',
    'time': '15:00:00Z',
    'Results': ?results,
    'SprintResults': ?sprintResults,
    'QualifyingResults': ?qualifyingResults,
  };

  static Map<String, dynamic> mrDataRaceTable({required List<Map<String, dynamic>> races, Object total = 1}) => {
    'MRData': {
      'total': total,
      'RaceTable': {'season': '2024', 'round': '1', 'Races': races},
    },
  };

  static Map<String, dynamic> emptyRaceTable({Object total = 0}) => mrDataRaceTable(races: const [], total: total);

  static Map<String, dynamic> mrDataDriverTable({required List<Map<String, dynamic>> drivers, Object total = 1}) => {
    'MRData': {
      'total': total,
      'DriverTable': {'Drivers': drivers},
    },
  };

  static Map<String, dynamic> mrDataConstructorTable({
    required List<Map<String, dynamic>> constructors,
    Object total = 1,
  }) => {
    'MRData': {
      'total': total,
      'ConstructorTable': {'Constructors': constructors},
    },
  };

  static Map<String, dynamic> qualifyingEntry({
    String position = '1',
    Map<String, dynamic>? driver,
    Map<String, dynamic>? constructor,
  }) => {
    'number': '1',
    'position': position,
    'Driver': driver ?? driverJson,
    'Constructor': constructor ?? constructorJson,
    'Q1': '1:10.000',
    'Q2': '1:09.000',
    'Q3': '1:08.000',
  };

  /// `MRData` payload for driver standings (what DayPrefs stores / StandingsModel parses).
  static Map<String, dynamic> driversStandingsMrData() => {
    'total': '1',
    'StandingsTable': {
      'StandingsLists': [
        {
          'season': '2024',
          'round': '5',
          'DriverStandings': [
            {
              'position': '1',
              'positionText': '1',
              'points': '100',
              'wins': '3',
              'Driver': driverJson,
              'Constructors': [constructorJson],
            },
          ],
        },
      ],
    },
  };

  static Map<String, dynamic> constructorsStandingsMrData() => {
    'total': '1',
    'StandingsTable': {
      'StandingsLists': [
        {
          'season': '2024',
          'round': '5',
          'ConstructorStandings': [
            {
              'position': '1',
              'positionText': '1',
              'points': '200',
              'wins': '5',
              'Constructor': constructorJson,
            },
          ],
        },
      ],
    },
  };

  static Map<String, dynamic> seasonsMrData() => {
    'total': '2',
    'SeasonTable': {
      'Seasons': [
        {'season': '2023', 'url': 'http://example.com/2023'},
        {'season': '2024', 'url': 'http://example.com/2024'},
      ],
    },
  };

  static Map<String, dynamic> scheduleMrData() => mrDataRaceTable(
    races: [
      race(results: [resultEntry()]),
    ],
    total: 1,
  )['MRData'] as Map<String, dynamic>;
}
