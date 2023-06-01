import 'package:f1_pet_project/data/models/sections/circuits/circuit_model.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuit/circuit_screen.dart';
import 'package:f1_pet_project/presentation/sections/circuits/circuits_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

StatefulShellBranch circuitsBranch = StatefulShellBranch(
  restorationScopeId: 'branchCircuits',
  routes: <RouteBase>[
    GoRoute(
      path: '/circuits',
      pageBuilder: (context, state) => const MaterialPage<void>(
        restorationId: 'screenCircuits',
        child: CircuitsScreen(),
      ),
      routes: [
        GoRoute(
          path: 'circuit',
          pageBuilder: (context, state) => MaterialPage<void>(
            restorationId: 'screenCircuit',
            child: CircuitScreen(circuitModel: state.extra as CircuitModel),
          ),
        ),
      ],
    ),
  ],
);
