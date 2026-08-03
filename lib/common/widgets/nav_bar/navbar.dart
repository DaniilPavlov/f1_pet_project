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
class NavBar extends StatelessWidget {
  const NavBar({this.tabsRouter, super.key});
  final TabsRouter? tabsRouter;

  static const _tabNames = ['home', 'results', 'schedule', 'predictor', 'profile'];

  void _switchTab(BuildContext context, int index) {
    final router = tabsRouter;
    if (router != null && router.activeIndex == index) {
      router.stackRouterOfIndex(index)?.popUntilRoot();
      return;
    }
    router?.setActiveIndex(index);
    context.read<AnalyticsGateway>().log(TabSwitched(tab: _tabNames[index]));
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;

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
                  isSelected: tabsRouter?.activeIndex == 0,
                  onPressed: () => _switchTab(context, 0),
                ),
                NavBarItem(
                  imageAsset: Assets.navBar.racingCar,
                  title: context.l10n.navResults,
                  isSelected: tabsRouter?.activeIndex == 1,
                  onPressed: () => _switchTab(context, 1),
                ),
                NavBarItem(
                  imageAsset: Assets.navBar.lights,
                  title: context.l10n.navCalendar,
                  isSelected: tabsRouter?.activeIndex == 2,
                  onPressed: () => _switchTab(context, 2),
                ),
                NavBarItem(
                  imageAsset: Assets.navBar.helmet,
                  title: context.l10n.navPredictor,
                  isSelected: tabsRouter?.activeIndex == 3,
                  onPressed: () => _switchTab(context, 3),
                ),
                NavBarItem(
                  imageAsset: Assets.navBar.trophy,
                  title: context.l10n.navProfile,
                  isSelected: tabsRouter?.activeIndex == 4,
                  onPressed: () => _switchTab(context, 4),
                ),
              ],
            ),
          ),
        ),
        Container(height: 4, color: AppTheme.red),
      ],
    );
  }
}
