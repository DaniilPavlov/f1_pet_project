import 'package:f1_pet_project/common/utils/helpers/network_reachability_stub.dart'
    if (dart.library.io) 'package:f1_pet_project/common/utils/helpers/network_reachability_io.dart' as impl;
import 'package:flutter/foundation.dart';

/// Быстрая проверка отсутствия сети (для баннера на cache-hit).
abstract final class NetworkReachability {
  /// Override for unit tests (avoid real sockets).
  @visibleForTesting
  static Future<bool> Function()? debugIsOfflineOverride;

  static Future<bool>? _inFlight;
  static bool? _memoized;
  static DateTime? _memoizedAt;

  static const _memoTtl = Duration(seconds: 2);

  /// Сброс memo (после resume / перед повторной проверкой баннера).
  static void clearMemo() {
    _inFlight = null;
    _memoized = null;
    _memoizedAt = null;
  }

  @visibleForTesting
  static void resetMemoForTest() => clearMemo();

  static Future<bool> isOffline() {
    final override = debugIsOfflineOverride;
    if (override != null) {
      return override();
    }

    final cached = _memoized;
    final at = _memoizedAt;
    if (cached != null && at != null && DateTime.now().difference(at) < _memoTtl) {
      return Future<bool>.value(cached);
    }

    return _inFlight ??= _probe().whenComplete(() => _inFlight = null);
  }

  static Future<bool> _probe() async {
    final value = await impl.isOffline();
    _memoized = value;
    _memoizedAt = DateTime.now();
    return value;
  }
}
