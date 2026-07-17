import 'package:flutter/cupertino.dart';

/// Поведение прокрутки без эффекта overscroll glow.
class AntiGlowBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
