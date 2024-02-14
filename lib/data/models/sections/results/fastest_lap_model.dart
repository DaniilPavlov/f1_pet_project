import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/results/average_speed_model.dart';
import 'package:f1_pet_project/data/models/sections/results/time_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'fastest_lap_model.g.dart';

@JsonSerializable()
class FastestLapModel {
  FastestLapModel({
    required this.averageSpeed,
    required this.time,
    required this.lap,
    required this.rank,
  });

  factory FastestLapModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$FastestLapModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('FastestLapModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String rank;
  final String lap;
  @JsonKey(name: 'Time')
  final TimeModel time;
  @JsonKey(name: 'AverageSpeed')
  final AverageSpeedModel averageSpeed;
}
