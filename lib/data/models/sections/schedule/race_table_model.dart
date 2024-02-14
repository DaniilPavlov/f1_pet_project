import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/schedule/races_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'race_table_model.g.dart';

@JsonSerializable()
class RaceTableModel {
  RaceTableModel({
    required this.races,
    required this.season,
    required this.round,
  });

  factory RaceTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RaceTableModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('RaceTableModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String season;
  final String? round;
  @JsonKey(name: 'Races')
  final List<RacesModel> races;

  @override
  String toString() =>
      'RaceTableModel(season: $season, round: $round, Races: $races)';
}
