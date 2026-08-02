import 'package:f1_pet_project/common/models/espn/espn_scoreboard_models.dart';
import 'package:f1_pet_project/common/utils/constants/assets.dart';
import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// Карточка сводки уикенда (ESPN scoreboard) для шаринга картинкой.
class ShareWeekendSummaryCard extends StatelessWidget {
  const ShareWeekendSummaryCard({
    required this.l10n,
    required this.event,
    required this.locale,
    this.podiumTopN = 3,
    super.key,
  });

  final AppLocalizations l10n;
  final EspnScoreboardEvent event;
  final Locale locale;
  final int podiumTopN;

  @override
  Widget build(BuildContext context) {
    final title = event.shortName.isNotEmpty ? event.shortName : event.name;
    final locationParts = [
      if (event.circuitCity != null && event.circuitCity!.isNotEmpty) event.circuitCity,
      if (event.circuitCountry != null && event.circuitCountry!.isNotEmpty) event.circuitCountry,
    ];
    final dateFormat = DateFormat.MMMd(locale.toLanguageTag()).add_Hm();
    final highlighted = event.highlightedSession;
    EspnScoreboardSession? podiumSession;
    for (final session in event.sessions) {
      if (session.abbreviation.toLowerCase().contains('race') && session.hasResults) {
        podiumSession = session;
        break;
      }
    }
    podiumSession ??= (highlighted?.hasResults ?? false) ? highlighted : null;
    final podium = podiumSession?.results.take(podiumTopN).toList() ?? const <EspnScoreboardResultEntry>[];
    final isLive = event.isLive || (highlighted?.isLive ?? false);
    final rawStatus =
        (highlighted?.statusDetail.isNotEmpty ?? false) ? highlighted!.statusDetail : event.statusDetail;
    final statusLabel = isLive
        ? l10n.homeWeekendLive
        : (looksLikeEspnScheduleClock(rawStatus)
            ? (highlighted?.date != null
                ? dateFormat.format(highlighted!.date!)
                : (event.startDate != null ? dateFormat.format(event.startDate!) : ''))
            : rawStatus);

    return Container(
      width: 360,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.light.white,
        border: Border.all(color: AppTheme.red, width: 2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(width: 40, height: 4, color: AppTheme.red),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(title, style: AppStyles.h2.copyWith(fontSize: 24, height: 1.15)),
              ),
              if (statusLabel.isNotEmpty) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: isLive ? AppTheme.red : AppColors.light.black,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusLabel,
                    style: AppStyles.caption.copyWith(color: AppTheme.onChrome),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Text(
            l10n.homeWeekendTitle,
            style: AppStyles.body.copyWith(color: AppColors.light.textGray),
          ),
          if (event.circuitName != null && event.circuitName!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              event.circuitName!,
              style: AppStyles.body.copyWith(color: AppColors.light.textGray),
            ),
          ],
          if (locationParts.isNotEmpty) ...[
            const SizedBox(height: 2),
            Text(
              locationParts.join(', '),
              style: AppStyles.caption.copyWith(color: AppColors.light.textGray),
            ),
          ],
          if (event.sessions.isNotEmpty) ...[
            const SizedBox(height: 16),
            for (var i = 0; i < event.sessions.length; i++) ...[
              if (i > 0) Divider(height: 1, color: AppColors.light.strokeGray),
              _SessionRow(session: event.sessions[i], l10n: l10n, dateFormat: dateFormat),
            ],
          ],
          if (podium.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.shareWeekendPodium,
              style: AppStyles.body.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            for (var i = 0; i < podium.length; i++) ...[
              if (i > 0) Divider(height: 1, color: AppColors.light.strokeGray),
              _PodiumRow(entry: podium[i]),
            ],
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Image.asset(Assets.appLogo, height: 18),
              const SizedBox(width: 8),
              Text('F1 App', style: AppStyles.caption.copyWith(color: AppColors.light.textGray)),
            ],
          ),
        ],
      ),
    );
  }
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({
    required this.session,
    required this.l10n,
    required this.dateFormat,
  });

  final EspnScoreboardSession session;
  final AppLocalizations l10n;
  final DateFormat dateFormat;

  @override
  Widget build(BuildContext context) {
    final leader = session.leaderName;
    final leaderLabel = leader == null || leader.isEmpty
        ? null
        : (session.isWinner ? l10n.homeWeekendWinner(leader) : l10n.homeWeekendLeader(leader));

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 48,
            child: Text(
              session.abbreviation,
              style: AppStyles.caption.copyWith(
                fontWeight: FontWeight.w700,
                color: session.isLive ? AppTheme.red : AppColors.light.black,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (session.date != null)
                  Text(
                    dateFormat.format(session.date!),
                    style: AppStyles.caption.copyWith(color: AppColors.light.textGray),
                  ),
                if (leaderLabel != null) ...[
                  const SizedBox(height: 2),
                  Text(leaderLabel, style: AppStyles.body.copyWith(fontWeight: FontWeight.w600)),
                ],
              ],
            ),
          ),
          if (session.isLive) ...[
            const SizedBox(width: 8),
            Text(
              l10n.homeWeekendLive,
              style: AppStyles.caption.copyWith(color: AppTheme.red),
            ),
          ],
        ],
      ),
    );
  }
}

class _PodiumRow extends StatelessWidget {
  const _PodiumRow({required this.entry});

  final EspnScoreboardResultEntry entry;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${entry.position}',
              style: AppStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                color: entry.isWinner ? AppTheme.red : AppColors.light.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              entry.displayName,
              style: AppStyles.body.copyWith(
                fontWeight: FontWeight.w600,
                color: entry.isWinner ? AppTheme.red : AppColors.light.black,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
