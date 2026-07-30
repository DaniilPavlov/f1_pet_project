import 'package:f1_pet_project/common/utils/helpers/career_api_helper.dart';
import 'package:f1_pet_project/core/results/finish_status/models/finish_status_item.dart';
import 'package:f1_pet_project/core/results/finish_status/repositories/finish_status_repository.dart';
import 'package:f1_pet_project/services/api_loader.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../helpers/fake_request_handler.dart';

void main() {
  setUp(CareerApiHelper.resetThrottleForTest);

  group('FinishStatusRepository', () {
    test('forSeason parses and sorts by count desc', () async {
      ApiLoader.configure(
        FakeRequestHandler(
          responses: {
            '2024/status': {
              'MRData': {
                'StatusTable': {
                  'Status': [
                    {'statusId': '1', 'status': 'Finished', 'count': '10'},
                    {'statusId': '2', 'status': 'Retired', 'count': 20},
                    {'statusId': '3', 'status': 'Accident', 'count': 5},
                  ],
                },
              },
            },
          },
        ),
      );

      final items = await const FinishStatusRepository().forSeason(year: '2024');
      expect(items.map((e) => e.status), ['Retired', 'Finished', 'Accident']);
      expect(items.first.count, 20);
      expect(items.first.isHighlight, isTrue);
      expect(items[1].isHighlight, isFalse);
    });

    test('returns empty on bad payload', () async {
      ApiLoader.configure(
        FakeRequestHandler(
          responses: {
            '2024/status': {
              'MRData': {'StatusTable': 'nope'},
            },
          },
        ),
      );

      expect(await const FinishStatusRepository().forSeason(year: '2024'), isEmpty);
    });
  });

  group('FinishStatusItem.isHighlight', () {
    test('detects DNF-like statuses', () {
      expect(const FinishStatusItem(statusId: '1', status: 'Collision', count: 1).isHighlight, isTrue);
      expect(const FinishStatusItem(statusId: '1', status: '+1 Lap', count: 1).isHighlight, isTrue);
      expect(const FinishStatusItem(statusId: '1', status: 'Finished', count: 1).isHighlight, isFalse);
    });
  });
}
