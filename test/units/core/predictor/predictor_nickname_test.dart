import 'package:f1_pet_project/core/predictor/services/predictor_nickname.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('PredictorNickname', () {
    test('validate accepts 3–16 alphanumerics and underscore', () {
      expect(PredictorNickname.validate('abc'), isNull);
      expect(PredictorNickname.validate('Max_33'), isNull);
      expect(PredictorNickname.validate('a' * 16), isNull);
    });

    test('validate rejects length and illegal chars', () {
      expect(PredictorNickname.validate('ab'), 'predictorNicknameErrorLength');
      expect(PredictorNickname.validate('a' * 17), 'predictorNicknameErrorLength');
      expect(PredictorNickname.validate('bad nick'), 'predictorNicknameErrorChars');
      expect(PredictorNickname.validate('ник'), 'predictorNicknameErrorChars');
    });

    test('normalize trims and lowercases', () {
      expect(PredictorNickname.normalize('  Max_33 '), 'max_33');
    });
  });
}
