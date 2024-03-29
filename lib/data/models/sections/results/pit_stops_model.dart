import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'pit_stops_model.g.dart';

@JsonSerializable()
class PitStopsModel {
  PitStopsModel({
    required this.driverId,
    required this.lap,
    required this.stop,
    required this.time,
    required this.duration,
  });

  factory PitStopsModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$PitStopsModelFromJson(json);
    } catch (e) {
      Error.throwWithStackTrace(
        ResponseParseException('PitStopsModel: $e'),
        StackTrace.current,
      );
    }
  }
  final String driverId;
  final String lap;
  final String stop;
  final String time;
  final String duration;

  PitStopsModel copyWith({
    String? driverId,
    String? lap,
    String? stop,
    String? time,
    String? duration,
  }) {
    return PitStopsModel(
      driverId: driverId ?? this.driverId,
      lap: lap ?? this.lap,
      stop: stop ?? this.stop,
      time: time ?? this.time,
      duration: duration ?? this.duration,
    );
  }
}
