import 'package:f1_pet_project/common/widgets/shimmer/list_rows_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/shimmer_skeleton.dart';
import 'package:f1_pet_project/common/widgets/shimmer/tournament_tables_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';


void main() {
  group('TournamentTablesShimmer', () {
    testWidgets('builds shimmer skeleton tree', (tester) async {
      await tester.pumpApp(const SingleChildScrollView(child: TournamentTablesShimmer()));

      expect(find.byType(ScreenShimmer), findsOneWidget);
      expect(find.byType(ShimmerSkeleton), findsWidgets);
      expect(find.byType(ShimmerTextLine), findsWidgets);
    });

    testWidgets('golden', (tester) async {
      await tester.pumpApp(
        const ColoredBox(
          color: Colors.white,
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(child: TournamentTablesShimmer()),
          ),
        ),
        surfaceSize: const Size(390, 640),
      );
      await tester.pumpForGolden();

      await expectLater(
        find.byType(TournamentTablesShimmer),
        matchesGoldenFile('../goldens/tournament_tables_shimmer.png'),
      );
    });
  });

  group('ListRowsShimmer', () {
    testWidgets('builds requested row count', (tester) async {
      await tester.pumpApp(const SingleChildScrollView(child: ListRowsShimmer(rowCount: 5)));

      expect(find.byType(ScreenShimmer), findsOneWidget);
      expect(find.byType(ShimmerSkeleton), findsNWidgets(5));
    });

    testWidgets('golden', (tester) async {
      await tester.pumpApp(
        const ColoredBox(
          color: Colors.white,
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(child: ListRowsShimmer(rowCount: 6)),
          ),
        ),
        surfaceSize: const Size(390, 420),
      );
      await tester.pumpForGolden();

      await expectLater(find.byType(ListRowsShimmer), matchesGoldenFile('../goldens/list_rows_shimmer.png'));
    });
  });

  group('CircuitsShimmer', () {
    testWidgets('builds circuit card skeletons', (tester) async {
      await tester.pumpApp(const CircuitsShimmer());

      expect(find.byType(CircuitsShimmer), findsOneWidget);
      expect(find.byType(ScreenShimmer), findsWidgets);
    });
  });
}
