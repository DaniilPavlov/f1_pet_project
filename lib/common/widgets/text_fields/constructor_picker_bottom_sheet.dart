import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/default_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/shimmer/list_rows_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/core/home/models/standings/constructor/constructor_model.dart';
import 'package:flutter/material.dart';

/// Bottom sheet со списком конструкторов и опциональным поиском.
class ConstructorPickerBottomSheet extends StatefulWidget {
  const ConstructorPickerBottomSheet({
    required this.loadConstructors,
    this.selectedConstructorId,
    this.enableSearch = false,
    super.key,
  });

  final Future<List<ConstructorModel>> Function() loadConstructors;
  final String? selectedConstructorId;
  final bool enableSearch;

  @override
  State<ConstructorPickerBottomSheet> createState() => _ConstructorPickerBottomSheetState();
}

class _ConstructorPickerBottomSheetState extends State<ConstructorPickerBottomSheet> {
  late final Future<List<ConstructorModel>> _future = widget.loadConstructors();
  late final TextEditingController _searchController;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.7,
      child: DefaultBottomSheet(
        body: FutureBuilder<List<ConstructorModel>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const ListRowsShimmer(rowCount: 8, padding: EdgeInsets.zero);
            }
            final constructors = snapshot.data ?? const <ConstructorModel>[];
            if (constructors.isEmpty) {
              return Center(child: Text(context.l10n.constructorsLoadError, style: AppStyles.body));
            }

            final filtered = _filter(constructors, _query);

            return Column(
              children: [
                if (widget.enableSearch) ...[
                  CustomTextField(
                    controller: _searchController,
                    label: context.l10n.search,
                    hintText: context.l10n.h2hSearchConstructor,
                    onChanged: (value) => setState(() => _query = value.trim()),
                  ),
                  const SizedBox(height: 12),
                ],
                Expanded(
                  child: filtered.isEmpty
                      ? Center(child: Text(context.l10n.h2hConstructorsEmpty, style: AppStyles.body))
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.strokeGray),
                          itemBuilder: (context, index) {
                            final constructor = filtered[index];
                            final isSelected = constructor.constructorId == widget.selectedConstructorId;
                            return ListTile(
                              title: Text(
                                constructor.name,
                                style: AppStyles.body.copyWith(
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                  color: isSelected ? AppTheme.red : AppTheme.black,
                                ),
                              ),
                              trailing: isSelected ? const Icon(Icons.check, color: AppTheme.red) : null,
                              onTap: () => Navigator.of(context).pop(constructor),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  static List<ConstructorModel> _filter(List<ConstructorModel> constructors, String query) {
    final sorted = [...constructors]..sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
    if (query.isEmpty) {
      return sorted;
    }
    final needle = query.toLowerCase();
    return sorted.where((c) => c.name.toLowerCase().contains(needle)).toList(growable: false);
  }
}
