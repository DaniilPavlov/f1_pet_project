import 'package:f1_pet_project/common/localization/l10n_extensions.dart';
import 'package:f1_pet_project/common/utils/theme/app_styles.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:f1_pet_project/common/widgets/bottom_sheets/default_bottom_sheet.dart';
import 'package:f1_pet_project/common/widgets/shimmer/list_rows_shimmer.dart';
import 'package:f1_pet_project/common/widgets/text_fields/custom_text_field.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';
import 'package:flutter/material.dart';

/// Bottom sheet со списком пилотов и опциональным поиском.
class DriverPickerBottomSheet extends StatefulWidget {
  const DriverPickerBottomSheet({
    required this.loadDrivers,
    this.selectedDriverId,
    this.enableSearch = false,
    super.key,
  });

  final Future<List<DriverModel>> Function() loadDrivers;
  final String? selectedDriverId;
  final bool enableSearch;

  @override
  State<DriverPickerBottomSheet> createState() => _DriverPickerBottomSheetState();
}

class _DriverPickerBottomSheetState extends State<DriverPickerBottomSheet> {
  late final Future<List<DriverModel>> _future = widget.loadDrivers();
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
        body: FutureBuilder<List<DriverModel>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const ListRowsShimmer(rowCount: 8, padding: EdgeInsets.zero);
            }
            final drivers = snapshot.data ?? const <DriverModel>[];
            if (drivers.isEmpty) {
              return Center(child: Text(context.l10n.driversLoadError, style: AppStyles.body));
            }

            final filtered = _filter(drivers, _query);

            return Column(
              children: [
                if (widget.enableSearch) ...[
                  CustomTextField(
                    controller: _searchController,
                    label: context.l10n.search,
                    hintText: context.l10n.h2hSearchDriver,
                    onChanged: (value) => setState(() => _query = value.trim()),
                  ),
                  const SizedBox(height: 12),
                ],
                Expanded(
                  child: filtered.isEmpty
                      ? Center(child: Text(context.l10n.h2hDriversEmpty, style: AppStyles.body))
                      : ListView.separated(
                          itemCount: filtered.length,
                          separatorBuilder: (_, _) => const Divider(height: 1, color: AppTheme.strokeGray),
                          itemBuilder: (context, index) {
                            final driver = filtered[index];
                            final isSelected = driver.driverId == widget.selectedDriverId;
                            final title = '${driver.givenName} ${driver.familyName}'.trim();
                            return ListTile(
                              title: Text(
                                title,
                                style: AppStyles.body.copyWith(
                                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                                  color: isSelected ? AppTheme.red : AppTheme.black,
                                ),
                              ),
                              trailing: isSelected ? const Icon(Icons.check, color: AppTheme.red) : null,
                              onTap: () => Navigator.of(context).pop(driver),
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

  static List<DriverModel> _filter(List<DriverModel> drivers, String query) {
    final sorted = [...drivers]
      ..sort((a, b) => a.familyName.toLowerCase().compareTo(b.familyName.toLowerCase()));
    if (query.isEmpty) {
      return sorted;
    }
    final needle = query.toLowerCase();
    return sorted.where((driver) {
      final full = '${driver.givenName} ${driver.familyName}'.toLowerCase();
      final code = (driver.code ?? '').toLowerCase();
      return full.contains(needle) || code.contains(needle);
    }).toList(growable: false);
  }
}
