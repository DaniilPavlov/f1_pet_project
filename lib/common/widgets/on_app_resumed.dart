import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/widgets.dart';

/// Resume приложения + появление сети → [onResumed] (без перезагрузки данных).
class OnAppResumed extends StatefulWidget {
  const OnAppResumed({required this.onResumed, required this.child, super.key});

  /// Вызывается при resume и когда интерфейс сети доступен.
  final VoidCallback onResumed;
  final Widget child;

  @override
  State<OnAppResumed> createState() => _OnAppResumedState();
}

class _OnAppResumedState extends State<OnAppResumed> with WidgetsBindingObserver {
  StreamSubscription<List<ConnectivityResult>>? _connectivitySub;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    unawaited(_listenConnectivity());
  }

  Future<void> _listenConnectivity() async {
    final connectivity = Connectivity();
    try {
      await connectivity.checkConnectivity();
    } on Object {
      // Plugin missing in some tests — resume-only fallback.
    }
    _connectivitySub = connectivity.onConnectivityChanged.listen((results) {
      // Не только переход offline→online: иначе при гонке init баннер залипает.
      if (!_isNone(results)) {
        widget.onResumed();
      }
    });
  }

  static bool _isNone(List<ConnectivityResult> results) =>
      results.isEmpty || results.every((r) => r == ConnectivityResult.none);

  @override
  void dispose() {
    unawaited(_connectivitySub?.cancel() ?? Future<void>.value());
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      widget.onResumed();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
