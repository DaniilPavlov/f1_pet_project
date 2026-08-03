import 'dart:async';

/// Секундный тикер для countdown / перехода в lock.
class PredictorLockTicker {
  PredictorLockTicker({required this.onTick});

  final void Function() onTick;
  Timer? _timer;

  void start() {
    _timer?.cancel();
    onTick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => onTick());
  }

  void dispose() {
    _timer?.cancel();
    _timer = null;
  }
}
