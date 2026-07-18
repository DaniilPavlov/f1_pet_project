import 'package:flutter/material.dart';

/// Расширение [ScrollController] для прокрутки к концу списка.
extension ScrollControllerX on ScrollController {
  /// Плавно прокручивает к нижней границе контента.
  void animateToBottom({Duration duration = const Duration(milliseconds: 200), Curve curve = Curves.easeOutCubic}) {
    if (!hasClients) return;
    animateTo(position.maxScrollExtent, duration: duration, curve: curve);
  }
}
