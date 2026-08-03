import 'package:f1_pet_project/common/widgets/career/network_hero_photo.dart';
import 'package:f1_pet_project/common/widgets/shimmer/career_screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/circuit_screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/h2h_compare_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/race_section_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/season_rewind_shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/pump_app.dart';

void main() {
  group('CareerScreenShimmer', () {
    testWidgets('renders with and without photo', (tester) async {
      await tester.pumpApp(const CareerScreenShimmer());
      expect(find.byType(CareerScreenShimmer), findsOneWidget);

      await tester.pumpApp(const CareerScreenShimmer(showPhoto: false));
      expect(find.byType(CareerScreenShimmer), findsOneWidget);
    });
  });

  group('CircuitScreenShimmer', () {
    testWidgets('renders circuit skeleton', (tester) async {
      await tester.pumpApp(const CircuitScreenShimmer());
      expect(find.byType(CircuitScreenShimmer), findsOneWidget);
    });
  });

  group('SeasonRewindShimmer', () {
    testWidgets('renders with and without scrubber', (tester) async {
      await tester.pumpApp(const SingleChildScrollView(child: SeasonRewindShimmer()));
      expect(find.byType(SeasonRewindShimmer), findsOneWidget);

      await tester.pumpApp(const SingleChildScrollView(child: SeasonRewindShimmer(showScrubber: false)));
      expect(find.byType(SeasonRewindShimmer), findsOneWidget);
    });

    testWidgets('golden', (tester) async {
      await tester.pumpApp(
        const ColoredBox(
          color: Colors.white,
          child: Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(child: SeasonRewindShimmer()),
          ),
        ),
        surfaceSize: const Size(390, 640),
      );
      await tester.pumpForGolden();

      await expectLater(
        find.byType(SeasonRewindShimmer),
        matchesGoldenFile('../goldens/season_rewind_shimmer.png'),
      );
    });
  });

  group('H2hCompareShimmer', () {
    testWidgets('renders compare skeleton', (tester) async {
      await tester.pumpApp(const SingleChildScrollView(child: H2hCompareShimmer()));
      expect(find.byType(H2hCompareShimmer), findsOneWidget);
    });
  });

  group('Race section shimmers', () {
    testWidgets('render last race and race info skeletons', (tester) async {
      await tester.pumpApp(
        const SingleChildScrollView(
          child: Column(
            children: [
              LastRaceSectionShimmer(),
              RaceInfoShimmer(),
            ],
          ),
        ),
      );

      expect(find.byType(LastRaceSectionShimmer), findsOneWidget);
      expect(find.byType(RaceInfoShimmer), findsOneWidget);
    });

    testWidgets('RaceInfoShimmer golden', (tester) async {
      await tester.pumpApp(
        const ColoredBox(
          color: Colors.white,
          child: Align(
            alignment: Alignment.topCenter,
            child: RaceInfoShimmer(),
          ),
        ),
        surfaceSize: const Size(390, 720),
      );
      await tester.pumpForGolden();

      await expectLater(
        find.byType(RaceInfoShimmer),
        matchesGoldenFile('../goldens/race_info_shimmer.png'),
      );
    });
  });

  group('NetworkHeroPhoto', () {
    testWidgets('shows loading and placeholder states', (tester) async {
      await tester.pumpApp(const NetworkHeroPhoto(photoUrl: null, isLoading: true));
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      await tester.pumpApp(const NetworkHeroPhoto(photoUrl: null));
      expect(find.byIcon(Icons.person), findsOneWidget);

      await tester.pumpApp(
        const NetworkHeroPhoto(photoUrl: 'https://en.wikipedia.org/wiki/x.png'),
      );
      // Network load fails in test → placeholder via errorBuilder after frames.
      await tester.pump();
      await tester.pump(const Duration(seconds: 1));
      expect(find.byType(NetworkHeroPhoto), findsOneWidget);
    });
  });
}
