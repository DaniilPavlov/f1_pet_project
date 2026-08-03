import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Есть ли сетевой интерфейс (Wi‑Fi / cellular / …).
///
/// Не TCP-probe: иначе при Wi‑Fi и блокировке 1.1.1.1 баннер «офлайн» врёт.
/// В `flutter test` — online (override через [NetworkReachability.debugIsOfflineOverride]).
Future<bool> isOffline() async {
  if (Platform.environment.containsKey('FLUTTER_TEST')) {
    return false;
  }
  final results = await Connectivity().checkConnectivity();
  return results.isEmpty || results.every((r) => r == ConnectivityResult.none);
}
