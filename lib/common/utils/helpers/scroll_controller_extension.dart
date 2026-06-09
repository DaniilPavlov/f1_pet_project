import 'package:flutter/material.dart';

extension ScrollControllerX on ScrollController {
  void animateToBottom({
    Duration duration = const Duration(milliseconds: 200),
    Curve curve = Curves.easeOutCubic,
  }) {
    if (!hasClients) return;
    animateTo(position.maxScrollExtent, duration: duration, curve: curve);
  }
}
