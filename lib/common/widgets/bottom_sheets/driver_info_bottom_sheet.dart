import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/utils/utils.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/bottom_sheet_track.dart';
import 'package:f1_pet_project/common/widgets/buttons/black_button.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';
import 'package:flutter/material.dart';

/// Нижний лист с полной информацией о пилоте.
class DriverInfoBottomSheet extends StatelessWidget {
  const DriverInfoBottomSheet({required this.driver, super.key});

  final DriverModel driver;

  /// Открывает лист с данными [driver].
  static Future<void> show(BuildContext context, DriverModel driver) {
    return showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => DriverInfoBottomSheet(driver: driver),
    );
  }

  @override
  Widget build(BuildContext context) {
    final fullName = '${driver.givenName} ${driver.familyName}';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(10)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Center(child: BottomSheetTrack()),
          const SizedBox(height: 16),
          Text(fullName, style: AppStyles.h3, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          _InfoRow(label: 'Код', value: _displayOrDash(driver.code)),
          _InfoRow(label: 'Номер', value: _displayOrDash(driver.permanentNumber)),
          _InfoRow(label: 'Национальность', value: driver.nationality),
          _InfoRow(label: 'Дата рождения', value: _formatBirthDate(driver.dateOfBirth)),
          if (driver.url.isNotEmpty) ...[
            const SizedBox(height: 16),
            BlackButton(
              text: 'Открыть в Wikipedia',
              isDisabled: false,
              onTap: () => Utils.openUrl(rawUrl: driver.url, externalApplication: true),
            ),
          ],
        ],
      ),
    );
  }

  static String _displayOrDash(String? value) {
    if (value == null || value.isEmpty || value == 'none') {
      return '—';
    }
    return value;
  }

  static String _formatBirthDate(String raw) {
    final parts = raw.split('-');
    if (parts.length != 3) {
      return raw;
    }
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) {
      return raw;
    }
    return '$day ${Utils.getMonthNameByNumber(month: month)} $year';
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Expanded(
            child: Text(label, style: AppStyles.body.copyWith(color: AppTheme.textGray)),
          ),
          Expanded(
            child: Text(value, style: AppStyles.body, textAlign: TextAlign.right),
          ),
        ],
      ),
    );
  }
}
