import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/text_fields/constructor_picker_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:flutter/material.dart';

/// Read-only поле конструктора: открывает список из [loadConstructors].
class ConstructorPickerField extends StatefulWidget {
  const ConstructorPickerField({
    required this.constructor,
    required this.onChanged,
    required this.loadConstructors,
    this.enableSearch = false,
    this.label,
    this.hintText,
    super.key,
  });

  final ConstructorModel? constructor;
  final ValueChanged<ConstructorModel> onChanged;
  final Future<List<ConstructorModel>> Function() loadConstructors;
  final bool enableSearch;
  final String? label;
  final String? hintText;

  @override
  State<ConstructorPickerField> createState() => _ConstructorPickerFieldState();
}

class _ConstructorPickerFieldState extends State<ConstructorPickerField> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.constructor?.name ?? '');
  }

  @override
  void didUpdateWidget(covariant ConstructorPickerField oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.constructor?.name ?? '';
    if (_controller.text != next) {
      _controller.text = next;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
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
          label: widget.label ?? context.l10n.constructor,
          hintText: widget.hintText ?? context.l10n.selectConstructor,
          rightWidget: const Padding(
            padding: EdgeInsets.only(right: 16),
            child: Icon(Icons.expand_more, color: AppTheme.red, size: 22),
          ),
        ),
      ),
    );
  }

  Future<void> _openPicker(BuildContext context) async {
    final selected = await showModalBottomSheet<ConstructorModel>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => ConstructorPickerBottomSheet(
        loadConstructors: widget.loadConstructors,
        selectedConstructorId: widget.constructor?.constructorId,
        enableSearch: widget.enableSearch,
      ),
    );
    if (selected == null || !context.mounted) {
      return;
    }
    widget.onChanged(selected);
  }
}
