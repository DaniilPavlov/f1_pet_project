import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/core/circuits/stats/models/circuit_stats.dart';
import 'package:flutter/material.dart';

/// Сетка характеристик трассы: длина, круги, повороты, скорость, перепад.
class CircuitStatsGrid extends StatelessWidget {
  const CircuitStatsGrid({required this.stats, super.key});

  final CircuitStats stats;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final items = [
      _StatItem(label: l10n.circuitStatLength, value: stats.lengthLabel),
      _StatItem(label: l10n.circuitStatLaps, value: stats.lapsLabel),
      _StatItem(label: l10n.circuitStatTurns, value: stats.turnsLabel),
      _StatItem(label: l10n.circuitStatTopSpeed, value: stats.topSpeedLabel),
      _StatItem(label: l10n.circuitStatElevation, value: stats.elevationLabel),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        border: Border.all(color: AppTheme.red),
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        children: [
          for (var i = 0; i < items.length; i++) ...[
            if (i > 0) Container(width: 1, height: 44, color: AppTheme.strokeGray),
            Expanded(child: items[i]),
          ],
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          textAlign: TextAlign.center,
          style: AppStyles.body.copyWith(fontFamily: 'HelveticaNeueCyr-Bold', fontSize: 14, height: 18 / 14),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: AppStyles.caption.copyWith(color: AppTheme.textGray),
        ),
      ],
    );
  }
}
