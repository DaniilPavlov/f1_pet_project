import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/data/models/standings/constructor/constructor_model.dart';
import 'package:f1_pet_project/data/models/standings/driver/driver_model.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/material.dart';

/// Делает все ячейки строки таблицы кликабельными и открывает экран пилота.
List<Widget> tappableDriverRowCells({
  required List<Widget> children,
  required BuildContext context,
  required DriverModel driver,
  List<ConstructorModel> currentConstructors = const [],
}) {
  return [
    for (final child in children)
      TableCell(
        verticalAlignment: TableCellVerticalAlignment.middle,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => context.router.push(
            DriverRoute(driver: driver, currentConstructors: currentConstructors),
          ),
          child: child,
        ),
      ),
  ];
}
