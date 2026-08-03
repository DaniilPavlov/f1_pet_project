import 'package:f1_pet_project/common/utils/helpers/network_reachability.dart';
import 'package:f1_pet_project/common/utils/helpers/offline_cached_banner.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  tearDown(() {
    NetworkReachability.debugIsOfflineOverride = null;
    NetworkReachability.resetMemoForTest();
  });

  group('shouldShowOfflineCachedBanner', () {
    test('false when no content', () async {
      NetworkReachability.debugIsOfflineOverride = () async => true;
      expect(await shouldShowOfflineCachedBanner(hasCachedContent: false), isFalse);
    });

    test('false when online with content', () async {
      NetworkReachability.debugIsOfflineOverride = () async => false;
      expect(await shouldShowOfflineCachedBanner(hasCachedContent: true), isFalse);
    });

    test('true when offline with content', () async {
      NetworkReachability.debugIsOfflineOverride = () async => true;
      expect(await shouldShowOfflineCachedBanner(hasCachedContent: true), isTrue);
    });
  });

  group('clearOfflineBannerIfOnline', () {
    test('keeps false when already hidden', () async {
      NetworkReachability.debugIsOfflineOverride = () async => true;
      expect(await clearOfflineBannerIfOnline(currentlyShowing: false), isFalse);
    });

    test('clears when online', () async {
      NetworkReachability.debugIsOfflineOverride = () async => false;
      expect(await clearOfflineBannerIfOnline(currentlyShowing: true), isFalse);
    });

    test('keeps when still offline', () async {
      NetworkReachability.debugIsOfflineOverride = () async => true;
      expect(await clearOfflineBannerIfOnline(currentlyShowing: true), isTrue);
    });
  });
}
