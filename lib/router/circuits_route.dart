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
            // TODO(pavlov): routes with extras have this problem:
            // ════════ Exception caught by foundation library ════════════════════════════════
            // 'package:flutter/src/services/restoration.dart': Failed assertion: line 650 pos 12:
            // 'debugIsSerializableForRestoration(value)': is not true.
            // but navigation works correctly
            restorationId: 'screenCircuit',
            child: CircuitScreen(circuitModel: state.extra as CircuitModel),
          ),
        ),
      ],
    ),
  ],
);
