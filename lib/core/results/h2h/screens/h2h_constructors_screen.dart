import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/core/results/h2h/models/h2h_mode.dart';
import 'package:f1_pet_project/core/results/h2h/screens/h2h_screen.dart';
import 'package:flutter/material.dart';

/// Deep-link / Results-tile entry для режима конструкторов (тот же H2H UI).
@RoutePage()
class H2hConstructorsScreen extends StatelessWidget {
  const H2hConstructorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const H2hView(initialMode: H2hMode.constructors);
  }
}
