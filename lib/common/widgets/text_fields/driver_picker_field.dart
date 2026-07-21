import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/common/widgets/text_fields/driver_picker_bottom_sheet.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';
import 'package:flutter/material.dart';

/// Read-only поле пилота: открывает список из [loadDrivers].
class DriverPickerField extends StatefulWidget {
  const DriverPickerField({
    required this.driver,
    required this.onChanged,
    required this.loadDrivers,
    this.enableSearch = false,
    this.label,
    this.hintText,
    super.key,
  });

  final DriverModel? driver;
  final ValueChanged<DriverModel> onChanged;
  final Future<List<DriverModel>> Function() loadDrivers;
  final bool enableSearch;
  final String? label;
  final String? hintText;

  @override
  State<DriverPickerField> createState() => _DriverPickerFieldState();
}

class _DriverPickerFieldState extends State<DriverPickerField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: _title(widget.driver));
  }

  @override
  void didUpdateWidget(covariant DriverPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = _title(widget.driver);
    if (_controller.text != next) {
      _controller.text = next;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  static String _title(DriverModel? driver) {
    if (driver == null) {
      return '';
    }
    return '${driver.givenName} ${driver.familyName}'.trim();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => _openPicker(context),
      child: AbsorbPointer(
        child: CustomTextField(
          controller: _controller,
          readOnly: true,
          label: widget.label ?? context.l10n.driver,
          hintText: widget.hintText ?? context.l10n.selectDriver,
          rightWidget: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.expand_more, color: AppTheme.red, size: 22),
          ),
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<DriverModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => DriverPickerBottomSheet(
        loadDrivers: widget.loadDrivers,
        selectedDriverId: widget.driver?.driverId,
        enableSearch: widget.enableSearch,
      ),
    );
    if (selected == null || !context.mounted) {
      return;
    }
    widget.onChanged(selected);
  }
}
