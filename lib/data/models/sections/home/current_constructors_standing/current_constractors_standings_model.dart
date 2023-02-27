import 'package:flutter/foundation.dart';

@immutable
class CurrentConstructorsStandings {
  const CurrentConstructorsStandings({
    required this.standingsTable,
  });

  final StandingsTable standingsTable;

  factory CurrentConstructorsStandings.fromJson(Map<String, dynamic> json) =>
      CurrentConstructorsStandings(
          standingsTable: StandingsTable.fromJson(
              json['StandingsTable'] as Map<String, dynamic>));

  Map<String, dynamic> toJson() => {'StandingsTable': standingsTable.toJson()};

  CurrentConstructorsStandings clone() =>
      CurrentConstructorsStandings(standingsTable: standingsTable.clone());

  CurrentConstructorsStandings copyWith({StandingsTable? standingsTable}) =>
      CurrentConstructorsStandings(
        standingsTable: standingsTable ?? this.standingsTable,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CurrentConstructorsStandings &&
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
  final List<ConstructorsStandingsList> standingsLists;

  factory StandingsTable.fromJson(Map<String, dynamic> json) => StandingsTable(
      season: json['season'].toString(),
      standingsLists: (json['StandingsLists'] as List? ?? [])
          .map((e) =>
              ConstructorsStandingsList.fromJson(e as Map<String, dynamic>))
          .toList());

  Map<String, dynamic> toJson() => {
        'season': season,
        'StandingsLists': standingsLists.map((e) => e.toJson()).toList()
      };

  StandingsTable clone() => StandingsTable(
      season: season,
      standingsLists: standingsLists.map((e) => e.clone()).toList());

  StandingsTable copyWith(
          {String? season, List<ConstructorsStandingsList>? standingsLists}) =>
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
class ConstructorsStandingsList {
  const ConstructorsStandingsList({
    required this.season,
    required this.round,
    required this.constructorStandings,
  });

  final String season;
  final String round;
  final List<ConstructorStanding> constructorStandings;

  factory ConstructorsStandingsList.fromJson(Map<String, dynamic> json) =>
      ConstructorsStandingsList(
          season: json['season'].toString(),
          round: json['round'].toString(),
          constructorStandings: (json['ConstructorStandings'] as List? ?? [])
              .map((e) =>
                  ConstructorStanding.fromJson(e as Map<String, dynamic>))
              .toList());

  Map<String, dynamic> toJson() => {
        'season': season,
        'round': round,
        'ConstructorStandings':
            constructorStandings.map((e) => e.toJson()).toList()
      };

  ConstructorsStandingsList clone() => ConstructorsStandingsList(
      season: season,
      round: round,
      constructorStandings:
          constructorStandings.map((e) => e.clone()).toList());

  ConstructorsStandingsList copyWith(
          {String? season,
          String? round,
          List<ConstructorStanding>? constructorStandings}) =>
      ConstructorsStandingsList(
        season: season ?? this.season,
        round: round ?? this.round,
        constructorStandings: constructorStandings ?? this.constructorStandings,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConstructorsStandingsList &&
          season == other.season &&
          round == other.round &&
          constructorStandings == other.constructorStandings;

  @override
  int get hashCode =>
      season.hashCode ^ round.hashCode ^ constructorStandings.hashCode;
}

@immutable
class ConstructorStanding {
  const ConstructorStanding({
    required this.position,
    required this.positionText,
    required this.points,
    required this.wins,
    required this.constructor,
  });

  final String position;
  final String positionText;
  final String points;
  final String wins;
  final Constructor constructor;

  factory ConstructorStanding.fromJson(Map<String, dynamic> json) =>
      ConstructorStanding(
          position: json['position'].toString(),
          positionText: json['positionText'].toString(),
          points: json['points'].toString(),
          wins: json['wins'].toString(),
          constructor: Constructor.fromJson(
              json['Constructor'] as Map<String, dynamic>));

  Map<String, dynamic> toJson() => {
        'position': position,
        'positionText': positionText,
        'points': points,
        'wins': wins,
        'Constructor': constructor.toJson()
      };

  ConstructorStanding clone() => ConstructorStanding(
      position: position,
      positionText: positionText,
      points: points,
      wins: wins,
      constructor: constructor.clone());

  ConstructorStanding copyWith(
          {String? position,
          String? positionText,
          String? points,
          String? wins,
          Constructor? constructor}) =>
      ConstructorStanding(
        position: position ?? this.position,
        positionText: positionText ?? this.positionText,
        points: points ?? this.points,
        wins: wins ?? this.wins,
        constructor: constructor ?? this.constructor,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ConstructorStanding &&
          position == other.position &&
          positionText == other.positionText &&
          points == other.points &&
          wins == other.wins &&
          constructor == other.constructor;

  @override
  int get hashCode =>
      position.hashCode ^
      positionText.hashCode ^
      points.hashCode ^
      wins.hashCode ^
      constructor.hashCode;
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
