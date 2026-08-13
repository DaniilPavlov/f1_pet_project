import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/assets.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/nav_bar/nav_bar_item.dart';
import 'package:f1_pet_project/services/analytics/analytics_event.dart';
import 'package:f1_pet_project/services/analytics/analytics_gateway.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Нижняя панель навигации приложения.
///
/// Красный сегмент сверху скользит к активной вкладке через явный
/// [AnimationController] и [CustomPainter].
class NavBar extends StatefulWidget {
  const NavBar({this.tabsRouter, super.key});
  final TabsRouter? tabsRouter;

  static const _tabNames = ['home', 'results', 'schedule', 'predictor', 'profile'];
  static const _tabCount = 5;

  @override
  State<NavBar> createState() => _NavBarState();
}

/// Состояние скользящего индикатора вкладок.
class _NavBarState extends State<NavBar> with SingleTickerProviderStateMixin {
  late final AnimationController _slide;
  late Animation<double> _indexAnim;
  double _fromIndex = 0;
  double _toIndex = 0;

  TabsRouter? get _router => widget.tabsRouter;

  int get _activeIndex => _router?.activeIndex ?? 0;

  @override
  void initState() {
    super.initState();
    _toIndex = _activeIndex.toDouble();
    _fromIndex = _toIndex;
    _slide = AnimationController(vsync: this, duration: const Duration(milliseconds: 320));
    _indexAnim = AlwaysStoppedAnimation(_toIndex);
    _router?.addListener(_onTabChanged);
  }

  @override
  void didUpdateWidget(covariant NavBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.tabsRouter != widget.tabsRouter) {
      oldWidget.tabsRouter?.removeListener(_onTabChanged);
      widget.tabsRouter?.addListener(_onTabChanged);
      _snapTo(_activeIndex.toDouble());
    }
  }

  @override
  void dispose() {
    _router?.removeListener(_onTabChanged);
    _slide.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    final next = _activeIndex.toDouble();
    if (next == _toIndex && !_slide.isAnimating) {
      return;
    }
    _fromIndex = _indexAnim.value;
    _toIndex = next;
    _indexAnim = Tween<double>(begin: _fromIndex, end: _toIndex).animate(
      CurvedAnimation(parent: _slide, curve: Curves.easeOutCubic),
    );
    _slide.forward(from: 0);
  }

  void _snapTo(double index) {
    _fromIndex = index;
    _toIndex = index;
    _indexAnim = AlwaysStoppedAnimation(index);
    _slide.stop();
  }

  void _switchTab(BuildContext context, int index) {
    final router = _router;
    if (router != null && router.activeIndex == index) {
      router.stackRouterOfIndex(index)?.popUntilRoot();
      return;
    }
    router?.setActiveIndex(index);
    context.read<AnalyticsGateway>().log(TabSwitched(tab: NavBar._tabNames[index]));
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    final active = _activeIndex;

    return Stack(
      children: [
        Container(
          height: 80 + bottomInset,
          color: AppTheme.chrome,
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              StaticData.defaultHorizontalPadding,
              5,
              StaticData.defaultHorizontalPadding,
              bottomInset,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                NavBarItem(
                  imageAsset: Assets.navBar.home,
                  title: context.l10n.navHome,
                  isSelected: active == 0,
                  onPressed: () => _switchTab(context, 0),
                ),
                NavBarItem(
                  imageAsset: Assets.navBar.racingCar,
                  title: context.l10n.navResults,
                  isSelected: active == 1,
                  onPressed: () => _switchTab(context, 1),
                ),
                NavBarItem(
                  imageAsset: Assets.navBar.lights,
                  title: context.l10n.navCalendar,
                  isSelected: active == 2,
                  onPressed: () => _switchTab(context, 2),
                ),
                NavBarItem(
                  imageAsset: Assets.navBar.trophy,
                  title: context.l10n.navPredictor,
                  isSelected: active == 3,
                  onPressed: () => _switchTab(context, 3),
                ),
                NavBarItem(
                  imageAsset: Assets.navBar.helmet,
                  title: context.l10n.navProfile,
                  isSelected: active == 4,
                  onPressed: () => _switchTab(context, 4),
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          height: 4,
          child: AnimatedBuilder(
            animation: _slide,
            builder: (context, _) {
              return CustomPaint(
                painter: _NavTabIndicatorPainter(
                  index: _indexAnim.value,
                  tabCount: NavBar._tabCount,
                  horizontalPadding: StaticData.defaultHorizontalPadding,
                  color: AppTheme.red,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Красный сегмент над активной вкладкой (скользит между индексами).
class _NavTabIndicatorPainter extends CustomPainter {
  _NavTabIndicatorPainter({
    required this.index,
    required this.tabCount,
    required this.horizontalPadding,
    required this.color,
  });

  final double index;
  final int tabCount;
  final double horizontalPadding;
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    if (tabCount <= 0 || size.width <= 0) {
      return;
    }
    final contentW = size.width - horizontalPadding * 2;
    final tabW = contentW / tabCount;
    final segmentW = tabW * 0.55;
    final centerX = horizontalPadding + tabW * (index + 0.5);
    final left = centerX - segmentW / 2;
    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(left, 0, segmentW, size.height),
      Radius.circular(size.height / 2),
    );
    canvas.drawRRect(rect, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _NavTabIndicatorPainter oldDelegate) {
    return oldDelegate.index != index ||
        oldDelegate.tabCount != tabCount ||
        oldDelegate.horizontalPadding != horizontalPadding ||
        oldDelegate.color != color;
  }
}
