import 'package:f1_pet_project/data/models/standings/standings_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('StandingsModel tolerates null string fields in driver standings', () {
    final model = StandingsModel.fromJson({
      'StandingsTable': {
        'StandingsLists': [
          {
            'season': '2026',
            'round': '1',
            'DriverStandings': [
              {
                'position': null,
                'positionText': null,
                'points': null,
                'wins': null,
                'Driver': {
                  'driverId': 'max_verstappen',
                  'url': null,
                  'givenName': 'Max',
                  'familyName': 'Verstappen',
                  'dateOfBirth': null,
                  'nationality': null,
                  'code': 'VER',
                },
                'Constructors': null,
              },
            ],
          },
        ],
      },
    });

    final standing = model.standingsTable.standingsLists.first.driverStandings!.single;
    expect(standing.points, '0');
    expect(standing.wins, '0');
    expect(standing.position, '');
    expect(standing.constructors, isEmpty);
    expect(standing.driver.familyName, 'Verstappen');
  });

  test('StandingsModel tolerates null string fields in constructor standings', () {
    final model = StandingsModel.fromJson({
      'StandingsTable': {
        'StandingsLists': [
          {
            'season': '2026',
            'round': '1',
            'ConstructorStandings': [
              {
                'position': null,
                'positionText': null,
                'points': null,
                'wins': null,
                'Constructor': {
                  'constructorId': 'red_bull',
                  'url': null,
                  'name': 'Red Bull',
                  'nationality': null,
                },
              },
            ],
          },
        ],
      },
    });

    final standing = model.standingsTable.standingsLists.first.constructorStandings!.single;
    expect(standing.points, '0');
    expect(standing.constructor.name, 'Red Bull');
    expect(standing.constructor.url, '');
  });
}
