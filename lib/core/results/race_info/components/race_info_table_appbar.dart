import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

/// Высота toolbar с названием секции.
const double kRaceInfoSectionToolbarHeight = 40;

/// Высота строки заголовков колонок.
const double kRaceInfoColumnHeadersHeight = 32;

/// Общая высота секционного [SliverAppBar].
const double kRaceInfoSectionAppBarHeight = kRaceInfoSectionToolbarHeight + kRaceInfoColumnHeadersHeight;

/// Секционный [SliverAppBar] без M3 surfaceTint (иначе toolbar темнее, чем bottom).
SliverAppBar raceInfoSectionSliverAppBar({
  required bool pinned,
  required Widget title,
  required PreferredSizeWidget bottom,
}) {
  return SliverAppBar(
    backgroundColor: AppTheme.red,
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.transparent,
    elevation: 0,
    scrolledUnderElevation: 0,
    pinned: pinned,
    automaticallyImplyLeading: false,
    centerTitle: true,
    titleSpacing: 0,
    toolbarHeight: kRaceInfoSectionToolbarHeight,
    title: title,
    bottom: bottom,
  );
}

/// Закрепляемая шапка колонок таблицы результатов гонки или спринта.
class RaceInfoTableAppBar extends StatelessWidget implements PreferredSizeWidget {
  const RaceInfoTableAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kRaceInfoColumnHeadersHeight);

  @override
  Widget build(BuildContext context) {
    final textStyle = AppStyles.caption.copyWith(color: AppTheme.onChrome);

    return SizedBox(
      height: kRaceInfoColumnHeadersHeight,
      child: Row(
        children: [
          Expanded(
            flex: 120,
            child: Text(context.l10n.driver, style: textStyle, textAlign: TextAlign.center, maxLines: 1),
          ),
          Expanded(
            flex: 135,
            child: Text(context.l10n.constructor, style: textStyle, textAlign: TextAlign.center, maxLines: 1),
          ),
          Expanded(
            flex: 115,
            child: Text(context.l10n.time, style: textStyle, textAlign: TextAlign.center, maxLines: 1),
          ),
          Expanded(
            flex: 45,
            child: Text(context.l10n.points, style: textStyle, textAlign: TextAlign.center, maxLines: 1),
          ),
          Expanded(
            flex: 85,
            child: Text(context.l10n.bestLap, style: textStyle, textAlign: TextAlign.center, maxLines: 1),
          ),
        ],
      ),
    );
  }
}

/// Название секции для [SliverAppBar.title].
class RaceInfoSectionTitle extends StatelessWidget {
  const RaceInfoSectionTitle(this.title, {super.key});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppStyles.h2.copyWith(color: AppTheme.onChrome),
      textAlign: TextAlign.center,
    );
  }
}
