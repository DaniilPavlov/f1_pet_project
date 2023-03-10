// ignore_for_file: non_constant_identifier_names

import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/data/models/sections/results/results_model.dart';
import 'package:f1_pet_project/data/models/sections/schedule/race_date_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'races_model.g.dart';

@JsonSerializable()
class RacesModel {
  final String season;
  final String round;
  final String url;
  final String raceName;
  final CircuitModel Circuit;
  final String date;
  final String? time;
  final RaceDateModel? FirstPractice;
  final RaceDateModel? SecondPractice;
  final RaceDateModel? ThirdPractice;
  final RaceDateModel? Qualifying;
  final RaceDateModel? Sprint;
  final List<ResultsModel>? Results;

  RacesModel({
    required this.season,
    required this.round,
    required this.url,
    required this.raceName,
    required this.Circuit,
    required this.date,
    required this.time,
    required this.FirstPractice,
    required this.SecondPractice,
    required this.ThirdPractice,
    required this.Qualifying,
    required this.Sprint,
    required this.Results,
  });

  factory RacesModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$RacesModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('RacesModel: $e');
    }
  }
}
