import 'package:flutter/foundation.dart';

@immutable
class SeasonsModel {
  const SeasonsModel({
    required this.seasonTable,
  });

  final SeasonTable seasonTable;

  factory SeasonsModel.fromJson(Map<String, dynamic> json) => SeasonsModel(
      seasonTable:
          SeasonTable.fromJson(json['SeasonTable'] as Map<String, dynamic>));

  Map<String, dynamic> toJson() => {'SeasonTable': seasonTable.toJson()};

  SeasonsModel clone() => SeasonsModel(seasonTable: seasonTable.clone());

  SeasonsModel copyWith({SeasonTable? seasonTable}) => SeasonsModel(
        seasonTable: seasonTable ?? this.seasonTable,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeasonsModel && seasonTable == other.seasonTable;

  @override
  int get hashCode => seasonTable.hashCode;
}

@immutable
class SeasonTable {
  const SeasonTable({
    required this.seasons,
  });

  final List<Season> seasons;

  factory SeasonTable.fromJson(Map<String, dynamic> json) => SeasonTable(
      seasons: (json['Seasons'] as List? ?? [])
          .map((e) => Season.fromJson(e as Map<String, dynamic>))
          .toList());

  Map<String, dynamic> toJson() =>
      {'Seasons': seasons.map((e) => e.toJson()).toList()};

  SeasonTable clone() =>
      SeasonTable(seasons: seasons.map((e) => e.clone()).toList());

  SeasonTable copyWith({List<Season>? seasons}) => SeasonTable(
        seasons: seasons ?? this.seasons,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SeasonTable && seasons == other.seasons;

  @override
  int get hashCode => seasons.hashCode;
}

@immutable
class Season {
  const Season({
    required this.season,
    required this.url,
  });

  final String season;
  final String url;

  factory Season.fromJson(Map<String, dynamic> json) =>
      Season(season: json['season'].toString(), url: json['url'].toString());

  Map<String, dynamic> toJson() => {'season': season, 'url': url};

  Season clone() => Season(season: season, url: url);

  Season copyWith({String? season, String? url}) => Season(
        season: season ?? this.season,
        url: url ?? this.url,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Season && season == other.season && url == other.url;

  @override
  int get hashCode => season.hashCode ^ url.hashCode;
}
