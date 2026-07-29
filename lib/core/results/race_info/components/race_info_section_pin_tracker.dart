import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';

/// Секции детального экрана гонки с закрепляемой шапкой.
enum RaceInfoPinnedSection { race, sprint, qualification, pitStops }

const _pinOffset = 100.0;

/// Определяет, должна ли секция ещё удерживать pinned-шапку.
@visibleForTesting
bool isRaceInfoSectionPinEligible(VisibilityInfo info) =>
    info.visibleBounds.top < info.size.height - _pinOffset && info.visibleBounds.right != 0;

/// Трекер: по VisibilityInfo секций выбирает одну активную шапку.
///
/// Заменяет связку GlobalKey + ScrollNotification. VisibilityDetector
/// вешаем на секцию целиком (предок горизонтального скролла таблицы),
/// поэтому nearest Scrollable — вертикальный CustomScrollView.
class RaceInfoSectionPinTracker extends ChangeNotifier {
  RaceInfoSectionPinTracker({this.hasSprint = false});

  bool hasSprint;

  final Map<RaceInfoPinnedSection, bool> _eligible = {
    RaceInfoPinnedSection.race: true,
    RaceInfoPinnedSection.sprint: false,
    RaceInfoPinnedSection.qualification: false,
    RaceInfoPinnedSection.pitStops: false,
  };

  RaceInfoPinnedSection? _active = RaceInfoPinnedSection.race;

  RaceInfoPinnedSection? get active => _active;

  bool get racePinned => _active == RaceInfoPinnedSection.race;
  bool get sprintPinned => _active == RaceInfoPinnedSection.sprint;
  bool get qualificationPinned => _active == RaceInfoPinnedSection.qualification;
  bool get pitStopsPinned => _active == RaceInfoPinnedSection.pitStops;

  void onSectionVisibility(RaceInfoPinnedSection section, VisibilityInfo info) {
    final eligible = isRaceInfoSectionPinEligible(info);
    if (_eligible[section] == eligible) {
      return;
    }
    _eligible[section] = eligible;
    final next = _resolveActive();
    if (next == _active) {
      return;
    }
    _active = next;
    notifyListeners();
  }

  RaceInfoPinnedSection? _resolveActive() {
    for (final section in RaceInfoPinnedSection.values) {
      if (section == RaceInfoPinnedSection.sprint && !hasSprint) {
        continue;
      }
      if (_eligible[section] ?? false) {
        return section;
      }
    }
    return null;
  }
}

/// Оборачивает контент секции в [VisibilityDetector] для [RaceInfoSectionPinTracker].
class RaceInfoSectionVisibility extends StatelessWidget {
  const RaceInfoSectionVisibility({
    required this.section,
    required this.tracker,
    required this.child,
    super.key,
  });

  final RaceInfoPinnedSection section;
  final RaceInfoSectionPinTracker tracker;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
      key: Key('race_info_section_${section.name}'),
      onVisibilityChanged: (info) => tracker.onSectionVisibility(section, info),
      child: child,
    );
  }
}
