import 'package:flutter/foundation.dart';

@immutable
class CurrentDriversStandings {
  const CurrentDriversStandings({
    required this.standingsTable,
  });

  final StandingsTable standingsTable;

  factory CurrentDriversStandings.fromJson(Map<String, dynamic> json) =>
      CurrentDriversStandings(
          standingsTable: StandingsTable.fromJson(
              json['StandingsTable'] as Map<String, dynamic>));

  Map<String, dynamic> toJson() => {'StandingsTable': standingsTable.toJson()};

  CurrentDriversStandings clone() =>
      CurrentDriversStandings(standingsTable: standingsTable.clone());

  CurrentDriversStandings copyWith({StandingsTable? standingsTable}) =>
      CurrentDriversStandings(
        standingsTable: standingsTable ?? this.standingsTable,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentDriversStandings &&
          standingsTable == other.standingsTable;

  @override
  int get hashCode => standingsTable.hashCode;
}

@immutable
class StandingsTable {
  const StandingsTable({
    required this.season,
    required this.standingsLists,
  });

  final String season;
  final List<StandingsList> standingsLists;

  factory StandingsTable.fromJson(Map<String, dynamic> json) => StandingsTable(
      season: json['season'].toString(),
      standingsLists: (json['StandingsLists'] as List? ?? [])
          .map((e) => StandingsList.fromJson(e as Map<String, dynamic>))
          .toList());

  Map<String, dynamic> toJson() => {
        'season': season,
        'StandingsLists': standingsLists.map((e) => e.toJson()).toList()
      };

  StandingsTable clone() => StandingsTable(
      season: season,
      standingsLists: standingsLists.map((e) => e.clone()).toList());

  StandingsTable copyWith(
          {String? season, List<StandingsList>? standingsLists}) =>
      StandingsTable(
        season: season ?? this.season,
        standingsLists: standingsLists ?? this.standingsLists,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StandingsTable &&
          season == other.season &&
          standingsLists == other.standingsLists;

  @override
  int get hashCode => season.hashCode ^ standingsLists.hashCode;
}

@immutable
class StandingsList {
  const StandingsList({
    required this.season,
    required this.round,
    required this.driverStandings,
  });

  final String season;
  final String round;
  final List<DriverStanding> driverStandings;

  factory StandingsList.fromJson(Map<String, dynamic> json) => StandingsList(
      season: json['season'].toString(),
      round: json['round'].toString(),
      driverStandings: (json['DriverStandings'] as List? ?? [])
          .map((e) => DriverStanding.fromJson(e as Map<String, dynamic>))
          .toList());

  Map<String, dynamic> toJson() => {
        'season': season,
        'round': round,
        'DriverStandings': driverStandings.map((e) => e.toJson()).toList()
      };

  StandingsList clone() => StandingsList(
      season: season,
      round: round,
      driverStandings: driverStandings.map((e) => e.clone()).toList());

  StandingsList copyWith(
          {String? season,
          String? round,
          List<DriverStanding>? driverStandings}) =>
      StandingsList(
        season: season ?? this.season,
        round: round ?? this.round,
        driverStandings: driverStandings ?? this.driverStandings,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StandingsList &&
          season == other.season &&
          round == other.round &&
          driverStandings == other.driverStandings;

  @override
  int get hashCode =>
      season.hashCode ^ round.hashCode ^ driverStandings.hashCode;
}

@immutable
class DriverStanding {
  const DriverStanding({
    required this.position,
    required this.positionText,
    required this.points,
    required this.wins,
    required this.driver,
    required this.constructors,
  });

  final String position;
  final String positionText;
  final String points;
  final String wins;
  final Driver driver;
  final List<Constructor> constructors;

  factory DriverStanding.fromJson(Map<String, dynamic> json) => DriverStanding(
      position: json['position'].toString(),
      positionText: json['positionText'].toString(),
      points: json['points'].toString(),
      wins: json['wins'].toString(),
      driver: Driver.fromJson(json['Driver'] as Map<String, dynamic>),
      constructors: (json['Constructors'] as List? ?? [])
          .map((e) => Constructor.fromJson(e as Map<String, dynamic>))
          .toList());

  Map<String, dynamic> toJson() => {
        'position': position,
        'positionText': positionText,
        'points': points,
        'wins': wins,
        'Driver': driver.toJson(),
        'Constructors': constructors.map((e) => e.toJson()).toList()
      };

  DriverStanding clone() => DriverStanding(
      position: position,
      positionText: positionText,
      points: points,
      wins: wins,
      driver: driver.clone(),
      constructors: constructors.map((e) => e.clone()).toList());

  DriverStanding copyWith(
          {String? position,
          String? positionText,
          String? points,
          String? wins,
          Driver? driver,
          List<Constructor>? constructors}) =>
      DriverStanding(
        position: position ?? this.position,
        positionText: positionText ?? this.positionText,
        points: points ?? this.points,
        wins: wins ?? this.wins,
        driver: driver ?? this.driver,
        constructors: constructors ?? this.constructors,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DriverStanding &&
          position == other.position &&
          positionText == other.positionText &&
          points == other.points &&
          wins == other.wins &&
          driver == other.driver &&
          constructors == other.constructors;

  @override
  int get hashCode =>
      position.hashCode ^
      positionText.hashCode ^
      points.hashCode ^
      wins.hashCode ^
      driver.hashCode ^
      constructors.hashCode;
}

@immutable
class Driver {
  const Driver({
    required this.driverId,
    required this.permanentNumber,
    required this.code,
    required this.url,
    required this.givenName,
    required this.familyName,
    required this.dateOfBirth,
    required this.nationality,
  });

  final String driverId;
  final String permanentNumber;
  final String code;
  final String url;
  final String givenName;
  final String familyName;
  final String dateOfBirth;
  final String nationality;

  factory Driver.fromJson(Map<String, dynamic> json) => Driver(
      driverId: json['driverId'].toString(),
      permanentNumber: json['permanentNumber'].toString(),
      code: json['code'].toString(),
      url: json['url'].toString(),
      givenName: json['givenName'].toString(),
      familyName: json['familyName'].toString(),
      dateOfBirth: json['dateOfBirth'].toString(),
      nationality: json['nationality'].toString());

  Map<String, dynamic> toJson() => {
        'driverId': driverId,
        'permanentNumber': permanentNumber,
        'code': code,
        'url': url,
        'givenName': givenName,
        'familyName': familyName,
        'dateOfBirth': dateOfBirth,
        'nationality': nationality
      };

  Driver clone() => Driver(
      driverId: driverId,
      permanentNumber: permanentNumber,
      code: code,
      url: url,
      givenName: givenName,
      familyName: familyName,
      dateOfBirth: dateOfBirth,
      nationality: nationality);

  Driver copyWith(
          {String? driverId,
          String? permanentNumber,
          String? code,
          String? url,
          String? givenName,
          String? familyName,
          String? dateOfBirth,
          String? nationality}) =>
      Driver(
        driverId: driverId ?? this.driverId,
        permanentNumber: permanentNumber ?? this.permanentNumber,
        code: code ?? this.code,
        url: url ?? this.url,
        givenName: givenName ?? this.givenName,
        familyName: familyName ?? this.familyName,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        nationality: nationality ?? this.nationality,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Driver &&
          driverId == other.driverId &&
          permanentNumber == other.permanentNumber &&
          code == other.code &&
          url == other.url &&
          givenName == other.givenName &&
          familyName == other.familyName &&
          dateOfBirth == other.dateOfBirth &&
          nationality == other.nationality;

  @override
  int get hashCode =>
      driverId.hashCode ^
      permanentNumber.hashCode ^
      code.hashCode ^
      url.hashCode ^
      givenName.hashCode ^
      familyName.hashCode ^
      dateOfBirth.hashCode ^
      nationality.hashCode;
}

@immutable
class Constructor {
  const Constructor({
    required this.constructorId,
    required this.url,
    required this.name,
    required this.nationality,
  });

  final String constructorId;
  final String url;
  final String name;
  final String nationality;

  factory Constructor.fromJson(Map<String, dynamic> json) => Constructor(
      constructorId: json['constructorId'].toString(),
      url: json['url'].toString(),
      name: json['name'].toString(),
      nationality: json['nationality'].toString());

  Map<String, dynamic> toJson() => {
        'constructorId': constructorId,
        'url': url,
        'name': name,
        'nationality': nationality
      };

  Constructor clone() => Constructor(
      constructorId: constructorId,
      url: url,
      name: name,
      nationality: nationality);

  Constructor copyWith(
          {String? constructorId,
          String? url,
          String? name,
          String? nationality}) =>
      Constructor(
        constructorId: constructorId ?? this.constructorId,
        url: url ?? this.url,
        name: name ?? this.name,
        nationality: nationality ?? this.nationality,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Constructor &&
          constructorId == other.constructorId &&
          url == other.url &&
          name == other.name &&
          nationality == other.nationality;

  @override
  int get hashCode =>
      constructorId.hashCode ^
      url.hashCode ^
      name.hashCode ^
      nationality.hashCode;
}
