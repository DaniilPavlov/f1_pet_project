import 'package:f1_pet_project/data/exceptions/response_parse_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'driver_model.freezed.dart';
part 'driver_model.g.dart';

/// Данные пилота F1.
@Freezed(fromJson: true, toJson: true)
abstract class DriverModel with _$DriverModel {
  const factory DriverModel({
    required String driverId,
    /// У старых пилотов в Jolpica иногда нет url / dateOfBirth / nationality —
    /// в модели остаётся пустая строка, в UI показывается l10n.unknown.
    @JsonKey(defaultValue: '') required String url,
    required String givenName,
    required String familyName,
    @JsonKey(defaultValue: '') required String dateOfBirth,
    @JsonKey(defaultValue: '') required String nationality,
    String? permanentNumber,
    String? code,
  }) = _DriverModel;

  /// Парсит JSON-ответ в [DriverModel].
  factory DriverModel.fromJson(Map<String, dynamic> json) {
    try {
      final model = _$DriverModelFromJson(json);
      return model.copyWith(code: model.code ?? 'none', permanentNumber: model.permanentNumber ?? 'none');
    } catch (e) {
      Error.throwWithStackTrace(ResponseParseException('DriverModel: $e'), StackTrace.current);
    }
  }
}
