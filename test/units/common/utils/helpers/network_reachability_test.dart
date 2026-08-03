import 'package:f1_pet_project/common/utils/helpers/network_reachability.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    NetworkReachability.debugIsOfflineOverride = null;
    NetworkReachability.resetMemoForTest();
  });

  test('uses debug override', () async {
    NetworkReachability.debugIsOfflineOverride = () async => true;
    expect(await NetworkReachability.isOffline(), isTrue);

    NetworkReachability.debugIsOfflineOverride = () async => false;
    expect(await NetworkReachability.isOffline(), isFalse);
  });
}
