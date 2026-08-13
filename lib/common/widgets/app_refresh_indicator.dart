import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Единый pull-to-refresh приложения (красный Material-индикатор).
///
/// Обёртка над [RefreshIndicator], чтобы цвет и параметры были в одном месте.
class AppRefreshIndicator extends StatelessWidget {
  const AppRefreshIndicator({
    required this.onRefresh,
    required this.child,
    this.displacement = 40,
    this.edgeOffset = 0,
    this.notificationPredicate = defaultScrollNotificationPredicate,
    this.triggerMode = RefreshIndicatorTriggerMode.onEdge,
    super.key,
  });

  final RefreshCallback onRefresh;
  final Widget child;
  final double displacement;
  final double edgeOffset;
  final ScrollNotificationPredicate notificationPredicate;
  final RefreshIndicatorTriggerMode triggerMode;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: AppTheme.red,
      displacement: displacement,
      edgeOffset: edgeOffset,
      notificationPredicate: notificationPredicate,
      triggerMode: triggerMode,
      onRefresh: onRefresh,
      child: child,
    );
  }
}
