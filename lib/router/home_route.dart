import 'package:f1_pet_project/presentation/sections/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

StatefulShellBranch homeBranch = StatefulShellBranch(
  restorationScopeId: 'branchHome',
  routes: <RouteBase>[
    GoRoute(
      path: '/home',
      pageBuilder: (context, state) => const MaterialPage<void>(
        restorationId: 'screenHome',
        child: HomeScreen(),
      ),
    ),
  ],
);
