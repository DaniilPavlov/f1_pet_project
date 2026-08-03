import 'package:f1_pet_project/common/utils/theme/app_colors.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/predictor/models/predictor_leaderboard_entry.dart';
import 'package:flutter/material.dart';

/// Строка лидерборда: место · ник · очки.
class PredictorLeaderboardTile extends StatelessWidget {
  const PredictorLeaderboardTile({
    required this.entry,
    this.isMe = false,
    super.key,
  });

  final PredictorLeaderboardEntry entry;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    final rank = entry.rank?.toString() ?? '—';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isMe ? AppTheme.red.withValues(alpha: 0.08) : context.colors.white,
        border: Border.all(
          color: isMe ? AppTheme.red : context.colors.textGray.withValues(alpha: 0.25),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(16)),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 36,
            child: Text(
              '#$rank',
              style: AppStyles.body.copyWith(
                fontWeight: FontWeight.w700,
                color: isMe ? AppTheme.red : context.colors.black,
              ),
            ),
          ),
          Expanded(
            child: Text(
              entry.nickname,
              style: AppStyles.body.copyWith(
                fontWeight: isMe ? FontWeight.w700 : FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '${entry.totalPoints}',
            style: AppStyles.body.copyWith(color: context.colors.textGray),
          ),
        ],
      ),
    );
  }
}
