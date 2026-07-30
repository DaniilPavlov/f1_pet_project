import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RaceReminderService.parseTapPayload', () {
    test('accepts race season/round deep link', () {
      final uri = RaceReminderService.parseTapPayload('f1pet://race/2026/12');
      expect(uri?.host, 'race');
      expect(uri?.pathSegments, ['2026', '12']);
    });

    test('accepts race/live deep link', () {
      expect(RaceReminderService.parseTapPayload('f1pet://race/live')?.pathSegments, ['live']);
    });

    test('rejects empty, legacy name, and foreign schemes', () {
      expect(RaceReminderService.parseTapPayload(null), isNull);
      expect(RaceReminderService.parseTapPayload(''), isNull);
      expect(RaceReminderService.parseTapPayload('Monaco Grand Prix'), isNull);
      expect(RaceReminderService.parseTapPayload('https://example.com'), isNull);
      expect(RaceReminderService.parseTapPayload('f1pet://driver/hamilton'), isNull);
    });
  });
}
