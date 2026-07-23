import 'package:f1_pet_project/common/utils/helpers/app_version.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppVersion.isLowerThan', () {
    test('equal versions are not lower', () {
      expect(AppVersion.isLowerThan('1.4.3', '1.4.3'), isFalse);
      expect(AppVersion.isLowerThan('0.0.0', '0.0.0'), isFalse);
    });

    test('lower patch / minor / major', () {
      expect(AppVersion.isLowerThan('1.4.2', '1.4.3'), isTrue);
      expect(AppVersion.isLowerThan('1.3.9', '1.4.0'), isTrue);
      expect(AppVersion.isLowerThan('0.9.9', '1.0.0'), isTrue);
    });

    test('higher version is not lower', () {
      expect(AppVersion.isLowerThan('1.4.3', '0.0.0'), isFalse);
      expect(AppVersion.isLowerThan('2.0.0', '1.9.9'), isFalse);
    });

    test('ignores build metadata', () {
      expect(AppVersion.isLowerThan('1.4.3+202607220', '1.4.4'), isTrue);
      expect(AppVersion.isLowerThan('1.4.3+1', '1.4.3'), isFalse);
    });
  });
}
