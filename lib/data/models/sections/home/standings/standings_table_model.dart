import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/home/standings/standings_lists_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'standings_table_model.g.dart';

@JsonSerializable()
class StandingsTableModel {
  StandingsTableModel({required this.standingsLists});

  factory StandingsTableModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$StandingsTableModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('StandingsTableModel: $e'),
        StackTrace.current,
      );
    }
  }
  @JsonKey(name: 'StandingsLists')
  final List<StandingsListsModel> standingsLists;
}
