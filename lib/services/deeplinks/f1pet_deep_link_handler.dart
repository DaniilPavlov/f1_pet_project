import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:f1_pet_project/router/app_router.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/services/di/app_providers.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_resolver.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Слушает `f1pet://…` и открывает экран во вкладке с корректным nested-стеком.
///
/// Также подписывается на [RaceReminderService.notificationTaps] (тот же контракт URI).
/// `race/…` ведёт на Schedule / Results — не на Race Info (там пусто до конца уикенда).
class F1PetDeepLinkHandler extends ConsumerStatefulWidget {
  const F1PetDeepLinkHandler({required this.forceUpdate, required this.router, super.key});

  final bool forceUpdate;
  final AppRouter router;

  @override
  ConsumerState<F1PetDeepLinkHandler> createState() => _F1PetDeepLinkHandlerState();
}

class _F1PetDeepLinkHandlerState extends ConsumerState<F1PetDeepLinkHandler> {
  final _appLinks = AppLinks();
  StreamSubscription<Uri>? _linkSub;
  StreamSubscription<Uri>? _reminderTapSub;
  String? _lastHandledLink;
  var _subscribedToReminders = false;

  @override
  void initState() {
    super.initState();
    _bootstrapDeepLinks();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Подписка до post-frame bootstrap reminders, чтобы не потерять cold-start tap.
    if (_subscribedToReminders) {
      return;
    }
    _subscribedToReminders = true;
    _reminderTapSub = ref.read(raceReminderServiceProvider).notificationTaps.listen((uri) {
      unawaited(_handleIncomingUri(uri));
    });
  }

  Future<void> _bootstrapDeepLinks() async {
    // Сначала подписка, потом cold-start link, чтобы не пропустить событие.
    _linkSub = _appLinks.uriLinkStream.listen(_handleIncomingUri, onError: (_) {});

    final initial = await _appLinks.getInitialLink();
    await _handleIncomingUri(initial);
  }

  Future<void> _handleIncomingUri(Uri? uri) async {
    if (uri == null || !mounted) {
      return;
    }
    if (widget.forceUpdate) {
      // Во время force update UI не показывает роуты.
      return;
    }
    if (_lastHandledLink == uri.toString()) {
      return;
    }
    _lastHandledLink = uri.toString();

    if (uri.scheme != 'f1pet') {
      return;
    }
    if (uri.pathSegments.isEmpty && uri.host != 'race') {
      return;
    }

    switch (uri.host) {
      case 'driver':
        {
          final id = uri.pathSegments.isEmpty ? '' : uri.pathSegments.first;
          if (id.isEmpty) {
            return;
          }
          final driver = await ref.read(driverCatalogRepositoryProvider).findByDriverId(id);
          if (driver == null || !mounted) {
            return;
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(
              widget.router.navigate(
                HomeRouter(
                  children: [
                    const HomeRoute(),
                    DriverRoute(driver: driver),
                  ],
                ),
              ),
            );
          });
          break;
        }

      case 'constructor':
        {
          final id = uri.pathSegments.isEmpty ? '' : uri.pathSegments.first;
          if (id.isEmpty) {
            return;
          }
          final constructor = await ref.read(constructorCatalogRepositoryProvider).findByConstructorId(id);
          if (constructor == null || !mounted) {
            return;
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(
              widget.router.navigate(
                HomeRouter(
                  children: [
                    const HomeRoute(),
                    ConstructorRoute(constructor: constructor),
                  ],
                ),
              ),
            );
          });
          break;
        }

      case 'circuit':
        {
          final id = uri.pathSegments.isEmpty ? '' : uri.pathSegments.first;
          if (id.isEmpty) {
            return;
          }
          final circuit = await ref.read(circuitsRepositoryProvider).findByCircuitId(id);
          if (circuit == null || !mounted) {
            return;
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(
              widget.router.navigate(
                ScheduleRouter(
                  children: [
                    const ScheduleRoute(),
                    const CircuitsRoute(),
                    CircuitRoute(circuitModel: circuit),
                  ],
                ),
              ),
            );
          });
          break;
        }

      case 'race':
        {
          final segments = uri.pathSegments;
          if (segments.isEmpty) {
            return;
          }
          // live / reminder: Race Info ещё пустой до конца уикенда —
          // ведём на Results (scoreboard) или Schedule (таймтейбл).
          if (segments.first == 'live') {
            await _ensureScoreboardLoaded();
            if (!mounted) {
              return;
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) {
                return;
              }
              unawaited(_navigateToResults());
            });
            return;
          }
          if (segments.length < 2) {
            return;
          }
          final openResults = await _shouldOpenResultsForRace(season: segments[0], round: segments[1]);
          if (!mounted) {
            return;
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(openResults ? _navigateToResults() : _navigateToSchedule());
          });
          break;
        }

      default:
        return;
    }
  }

  Future<void> _ensureScoreboardLoaded() async {
    final liveWeekend = ref.read(liveWeekendControllerProvider.notifier);
    final liveState = ref.read(liveWeekendControllerProvider);
    if (!liveState.scoreboard.isValue) {
      await liveWeekend.loadScoreboard();
    }
  }

  /// Live-уикенд по ESPN и совпадает с reminder → Results; иначе Schedule.
  Future<bool> _shouldOpenResultsForRace({required String season, required String round}) async {
    await _ensureScoreboardLoaded();
    if (!mounted) {
      return false;
    }
    final liveState = ref.read(liveWeekendControllerProvider);
    if (!liveState.isLive) {
      return false;
    }
    final schedule = await ref.read(scheduleRepositoryProvider).getSchedule();
    final liveRace = LiveWeekendResolver.resolve(
      races: schedule.schedule.raceTable.races,
      scoreboard: liveState.scoreboard.value,
    );
    return liveRace != null && liveRace.season == season && liveRace.round == round;
  }

  Future<void> _navigateToResults() {
    return widget.router.navigate(const ResultsRouter(children: [ResultsRoute()]));
  }

  Future<void> _navigateToSchedule() {
    return widget.router.navigate(const ScheduleRouter(children: [ScheduleRoute()]));
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    _reminderTapSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
