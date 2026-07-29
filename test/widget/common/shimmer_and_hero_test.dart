import 'package:f1_pet_project/common/widgets/career/network_hero_photo.dart';
import 'package:f1_pet_project/common/widgets/shimmer/career_screen_shimmer.dart';
import 'package:f1_pet_project/common/widgets/shimmer/race_section_shimmer.dart';
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
