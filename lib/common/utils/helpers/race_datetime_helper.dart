import 'package:f1_pet_project/core/schedule/models/race_date_model.dart';

/// Конвертация UTC-дат сессий Ergast/Jolpica в локальное время устройства.
abstract final class RaceDateTimeHelper {
  /// Парсит [RaceDateModel] (дата + время в UTC) в [DateTime] локального пояса.
  ///
  /// Пустое [RaceDateModel.time] трактуется как полночь UTC указанного дня.
  static DateTime toLocal(RaceDateModel date) {
    final timePart = date.time.trim().isEmpty ? '00:00:00' : date.time.trim();
    final normalized = timePart.endsWith('Z') ? timePart.substring(0, timePart.length - 1) : timePart;
    final utc = DateTime.parse('${date.date}T${normalized}Z');
    return utc.toLocal();
  }
}
