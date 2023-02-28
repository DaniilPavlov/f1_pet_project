import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:json_annotation/json_annotation.dart';

part 'constructor_model.g.dart';

@JsonSerializable()
class ConstructorModel {
  final String constructorId;
  final String url;
  final String name;
  final String nationality;

  ConstructorModel({
    required this.constructorId,
    required this.url,
    required this.nationality,
    required this.name,
  });

  factory ConstructorModel.fromJson(Map<String, dynamic> json) {
    try {
      return _$ConstructorModelFromJson(json);
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      throw ResponseParseException('ConstructorModel: $e');
    }
  }
}
