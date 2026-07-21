import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/constants/static_data.dart';
import 'package:f1_pet_project/common/utils/helpers/mobx_async_value.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/country_flag.dart';
import 'package:f1_pet_project/common/widgets/shimmer/weekend_scoreboard_shimmer.dart';
import 'package:f1_pet_project/core/espn/models/espn_scoreboard_models.dart';
import 'package:f1_pet_project/core/results/components/weekend_session_results_sheet.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Карточка текущего уикенда F1 (ESPN scoreboard) на Results.
class WeekendScoreboardSection extends StatelessWidget {
  const WeekendScoreboardSection({required this.scoreboard, required this.locale, super.key});

  final AsyncValue<EspnScoreboardEvent?> scoreboard;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final event = scoreboard.value;
    if (event != null) {
      return Padding(
        padding: const EdgeInsets.fromLTRB(
          StaticData.defaultHorizontalPadding,
          StaticData.defaultVerticalPadding,
          StaticData.defaultHorizontalPadding,
          0,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.homeWeekendTitle, style: AppStyles.h1),
            const SizedBox(height: 16),
            _ScoreboardCard(event: event, locale: locale),
          ],
        ),
      );
    }

    if (scoreboard.isLoading) {
      return const WeekendScoreboardSectionShimmer();
    }

    return const SizedBox.shrink();
  }
}

class _ScoreboardCard extends StatelessWidget {
  const _ScoreboardCard({required this.event, required this.locale});

  final EspnScoreboardEvent event;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    final highlighted = event.highlightedSession;
    final dateFormat = DateFormat.MMMd(locale.toLanguageTag()).add_Hm();
    final locationParts = [
      if (event.circuitCity != null && event.circuitCity!.isNotEmpty) event.circuitCity,
      if (event.circuitCountry != null && event.circuitCountry!.isNotEmpty) event.circuitCountry,
    ];
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.red),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  event.shortName.isNotEmpty ? event.shortName : event.name,
                  style: AppStyles.h3.copyWith(fontSize: 20, height: 24 / 20),
                ),
              ),
              const SizedBox(width: 8),
              _StatusChip(event: event, highlighted: highlighted),
            ],
          ),
          if (event.circuitName != null && event.circuitName!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(event.circuitName!, style: AppStyles.body),
          ],
          if (locationParts.isNotEmpty || (event.circuitCountry?.isNotEmpty ?? false)) ...[
            const SizedBox(height: 6),
            Row(
              children: [
                if (event.circuitCountry != null && event.circuitCountry!.isNotEmpty) ...[
                  CountryFlag(countryOrNationality: event.circuitCountry, fontSize: 20),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    locationParts.join(', '),
                    style: AppStyles.caption.copyWith(color: AppTheme.textGray),
                  ),
                ),
              ],
            ),
          ],
          if (highlighted != null) ...[
            const SizedBox(height: 14),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => WeekendSessionResultsSheet.show(context, highlighted),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.grayBG,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            highlighted.abbreviation,
                            style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(Icons.chevron_right, color: AppTheme.textGray.withValues(alpha: 0.9), size: 20),
                      ],
                    ),
                    if (highlighted.date != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        dateFormat.format(highlighted.date!),
                        style: AppStyles.caption.copyWith(color: AppTheme.textGray),
                      ),
                    ],
                    if (highlighted.leaderName != null && highlighted.leaderName!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        highlighted.isWinner
                            ? context.l10n.homeWeekendWinner(highlighted.leaderName!)
                            : context.l10n.homeWeekendLeader(highlighted.leaderName!),
                        style: AppStyles.body,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
          if (event.sessions.isNotEmpty) ...[
            const SizedBox(height: 14),
            ...event.sessions.map(
              (session) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => WeekendSessionResultsSheet.show(context, session),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 48,
                        child: Text(
                          session.abbreviation,
                          style: AppStyles.caption.copyWith(
                            color: identical(session, highlighted) ? AppTheme.red : AppTheme.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          session.date == null ? session.statusDetail : dateFormat.format(session.date!),
                          style: AppStyles.caption.copyWith(color: AppTheme.textGray),
                        ),
                      ),
                      Text(
                        session.statusDetail,
                        style: AppStyles.caption.copyWith(
                          color: session.isLive ? AppTheme.red : AppTheme.textGray,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Icon(Icons.chevron_right, size: 16, color: AppTheme.textGray.withValues(alpha: 0.8)),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.event, required this.highlighted});

  final EspnScoreboardEvent event;
  final EspnScoreboardSession? highlighted;

  @override
  Widget build(BuildContext context) {
    final isLive = event.isLive || (highlighted?.isLive ?? false);
    final label = isLive
        ? context.l10n.homeWeekendLive
        : ((highlighted?.statusDetail.isNotEmpty ?? false)
            ? highlighted!.statusDetail
            : event.statusDetail);

    if (label.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isLive ? AppTheme.red : AppTheme.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(label, style: AppStyles.caption.copyWith(color: AppTheme.white)),
    );
  }
}
