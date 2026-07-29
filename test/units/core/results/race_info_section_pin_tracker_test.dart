import 'package:f1_pet_project/core/results/race_info/components/race_info_section_pin_tracker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:visibility_detector/visibility_detector.dart';

void main() {
  group('isRaceInfoSectionPinEligible', () {
    test('true when enough of section remains below pin threshold', () {
      expect(
        isRaceInfoSectionPinEligible(
          const VisibilityInfo(
            key: Key('section'),
            size: Size(300, 400),
            visibleBounds: Rect.fromLTWH(0, 100, 300, 200),
          ),
        ),
        isTrue,
      );
    });

    test('false when scrolled past pin threshold', () {
      expect(
        isRaceInfoSectionPinEligible(
          const VisibilityInfo(
            key: Key('section'),
            size: Size(300, 400),
            visibleBounds: Rect.fromLTWH(0, 320, 300, 80),
          ),
        ),
        isFalse,
      );
    });

    test('false when not visible', () {
      expect(isRaceInfoSectionPinEligible(const VisibilityInfo(key: Key('section'), size: Size(300, 400))), isFalse);
    });
  });

  group('RaceInfoSectionPinTracker', () {
    test('keeps race pinned until it becomes ineligible', () {
      final tracker = RaceInfoSectionPinTracker();
      expect(tracker.racePinned, isTrue);

      tracker.onSectionVisibility(
        RaceInfoPinnedSection.qualification,
        const VisibilityInfo(key: Key('qual'), size: Size(300, 400), visibleBounds: Rect.fromLTWH(0, 0, 300, 400)),
      );
      // Race still eligible by default → stays active (first eligible wins).
      expect(tracker.racePinned, isTrue);

      tracker.onSectionVisibility(
        RaceInfoPinnedSection.race,
        const VisibilityInfo(key: Key('race'), size: Size(300, 400)),
      );
      expect(tracker.racePinned, isFalse);
      expect(tracker.qualificationPinned, isTrue);
    });

    test('skips sprint when hasSprint is false', () {
      final tracker = RaceInfoSectionPinTracker()
        ..onSectionVisibility(RaceInfoPinnedSection.race, const VisibilityInfo(key: Key('race'), size: Size(300, 400)))
        ..onSectionVisibility(
          RaceInfoPinnedSection.sprint,
          const VisibilityInfo(key: Key('sprint'), size: Size(300, 400), visibleBounds: Rect.fromLTWH(0, 0, 300, 400)),
        )
        ..onSectionVisibility(
          RaceInfoPinnedSection.qualification,
          const VisibilityInfo(key: Key('qual'), size: Size(300, 400), visibleBounds: Rect.fromLTWH(0, 0, 300, 400)),
        );

      expect(tracker.sprintPinned, isFalse);
      expect(tracker.qualificationPinned, isTrue);
    });
  });
}
