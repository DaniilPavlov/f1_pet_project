import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_catalog_repository.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/router/app_router.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_resolver.dart';
import 'package:f1_pet_project/services/notifications/race_reminder_service.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// Слушает `f1pet://…` и открывает экран во вкладке с корректным nested-стеком.
///
/// Также подписывается на [RaceReminderService.notificationTaps] (тот же контракт URI).
/// `race/…` ведёт на Schedule / Results — не на Race Info (там пусто до конца уикенда).
class F1PetDeepLinkHandler extends StatefulWidget {
  const F1PetDeepLinkHandler({required this.forceUpdate, required this.router, super.key});

  final bool forceUpdate;
  final AppRouter router;

  @override
  State<F1PetDeepLinkHandler> createState() => _F1PetDeepLinkHandlerState();
}

class _F1PetDeepLinkHandlerState extends State<F1PetDeepLinkHandler> {
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
    _reminderTapSub = context.read<RaceReminderService>().notificationTaps.listen((uri) {
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
          final driver = await context.read<DriverCatalogRepository>().findByDriverId(id);
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
          final constructor = await context.read<ConstructorCatalogRepository>().findByConstructorId(id);
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
          final circuit = await context.read<CircuitsRepository>().findByCircuitId(id);
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
    final liveWeekend = context.read<LiveWeekendController>();
    if (!liveWeekend.scoreboard.isValue) {
      await liveWeekend.loadScoreboard();
    }
  }

  /// Live-уикенд по ESPN и совпадает с reminder → Results; иначе Schedule.
  Future<bool> _shouldOpenResultsForRace({required String season, required String round}) async {
    await _ensureScoreboardLoaded();
    if (!mounted) {
      return false;
    }
    final liveWeekend = context.read<LiveWeekendController>();
    if (!liveWeekend.isLive) {
      return false;
    }
    final schedule = await context.read<ScheduleRepository>().getSchedule();
    final liveRace = LiveWeekendResolver.resolve(
      races: schedule.schedule.raceTable.races,
      scoreboard: liveWeekend.scoreboard.value,
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
