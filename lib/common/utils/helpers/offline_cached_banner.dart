import 'package:f1_pet_project/common/utils/helpers/network_reachability.dart';

/// Баннер «сохранённые данные»: есть контент и сейчас нет сети.
Future<bool> shouldShowOfflineCachedBanner({required bool hasCachedContent}) async {
  if (!hasCachedContent) {
    return false;
  }
  return NetworkReachability.isOffline();
}

/// Дешёво спрятать баннер после появления сети (без перезагрузки данных).
Future<bool> clearOfflineBannerIfOnline({required bool currentlyShowing}) async {
  if (!currentlyShowing) {
    return false;
  }
  NetworkReachability.clearMemo();
  return NetworkReachability.isOffline();
}
