import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_table_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'standings_model.g.dart';

@JsonSerializable()
class StandingsModel {
  StandingsModel({required this.standingsTable});

  factory StandingsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$StandingsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('StandingsModel: $e'),
        StackTrace.current,
      );
    }
  }
  @JsonKey(name: 'StandingsTable')
  final StandingsTableModel standingsTable;
}
