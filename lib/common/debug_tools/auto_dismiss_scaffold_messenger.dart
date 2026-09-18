import 'package:flutter/material.dart';

/// С Flutter 3.38 SnackBar с [SnackBar.action] по умолчанию `persist: true`
/// и не скрывается сам. Пакет `inspector` (pick tint) показывает такой SnackBar
/// с кнопкой Copy — из‑за этого баннер «Color: #…» зависает на экране.
///
/// Этот messenger принудительно выставляет `persist: false` и короткий duration,
/// чтобы цвет снова исчезал через пару секунд.
class AutoDismissScaffoldMessenger extends ScaffoldMessenger {
  const AutoDismissScaffoldMessenger({required super.child, super.key});

  @override
  ScaffoldMessengerState createState() => _AutoDismissScaffoldMessengerState();
}

class _AutoDismissScaffoldMessengerState extends ScaffoldMessengerState {
  static const _colorPickerDuration = Duration(seconds: 2);

  @override
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showSnackBar(
    SnackBar snackBar, {
    AnimationStyle? snackBarAnimationStyle,
  }) {
    // inspector color picker: action label == 'Copy'
    final isInspectorColorPicker = snackBar.action?.label == 'Copy';
    final resolved = (snackBar.persist || isInspectorColorPicker)
        ? SnackBar(
            key: snackBar.key,
            content: snackBar.content,
            backgroundColor: snackBar.backgroundColor,
            elevation: snackBar.elevation,
            margin: snackBar.margin,
            padding: snackBar.padding,
            width: snackBar.width,
            shape: snackBar.shape,
            hitTestBehavior: snackBar.hitTestBehavior,
            behavior: snackBar.behavior,
            action: snackBar.action,
            actionOverflowThreshold: snackBar.actionOverflowThreshold,
            showCloseIcon: snackBar.showCloseIcon,
            closeIconColor: snackBar.closeIconColor,
            duration: isInspectorColorPicker ? _colorPickerDuration : snackBar.duration,
            persist: false,
            animation: snackBar.animation,
            onVisible: snackBar.onVisible,
            dismissDirection: snackBar.dismissDirection,
            clipBehavior: snackBar.clipBehavior,
          )
        : snackBar;
    return super.showSnackBar(resolved, snackBarAnimationStyle: snackBarAnimationStyle);
  }
}
