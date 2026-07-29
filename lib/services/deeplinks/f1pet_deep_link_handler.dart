import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_catalog_repository.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/core/schedule/models/races_model.dart';
import 'package:f1_pet_project/core/schedule/repositories/schedule_repository.dart';
import 'package:f1_pet_project/router/app_router.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_controller.dart';
import 'package:f1_pet_project/services/live_weekend/live_weekend_resolver.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

/// Слушает `f1pet://…` и открывает экран во вкладке с корректным nested-стеком.
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
  String? _lastHandledLink;

  @override
  void initState() {
    super.initState();
    _bootstrapDeepLinks();
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
                CircuitsRouter(
                  children: [
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
          final segment = uri.pathSegments.isEmpty ? '' : uri.pathSegments.first;
          if (segment != 'live') {
            return;
          }
          final race = await _resolveLiveRace();
          if (!mounted) {
            return;
          }
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            unawaited(_navigateToLiveRace(race));
          });
          break;
        }

      default:
        return;
    }
  }

  Future<RacesModel?> _resolveLiveRace() async {
    final liveWeekend = context.read<LiveWeekendController>();
    final scheduleRepository = context.read<ScheduleRepository>();
    if (!liveWeekend.scoreboard.isValue) {
      await liveWeekend.loadScoreboard();
    }
    if (!mounted) {
      return null;
    }
    final schedule = await scheduleRepository.getSchedule();
    return LiveWeekendResolver.resolve(
      races: schedule.schedule.raceTable.races,
      scoreboard: liveWeekend.scoreboard.value,
    );
  }

  Future<void> _navigateToLiveRace(RacesModel? race) {
    if (race == null) {
      return widget.router.navigate(const ResultsRouter(children: [ResultsRoute()]));
    }
    return widget.router.navigate(
      ResultsRouter(
        children: [
          const ResultsRoute(),
          RaceInfoRoute(raceModel: race),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _linkSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
