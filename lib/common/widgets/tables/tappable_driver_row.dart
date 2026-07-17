import 'package:f1_pet_project/common/widgets/bottom_sheets/driver_info_bottom_sheet.dart';
import 'package:f1_pet_project/core/home/models/standings/driver/driver_model.dart';
import 'package:flutter/material.dart';

/// Делает все ячейки строки таблицы кликабельными и открывает карточку пилота.
List<Widget> tappableDriverRowCells({
  required List<Widget> children,
  required BuildContext context,
  required DriverModel driver,
}) {
  return [
    for (final child in children)
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => DriverInfoBottomSheet.show(context, driver),
          child: child,
        ),
      ),
  ];
}
