import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:auto_route/auto_route.dart';
import 'package:f1_pet_project/core/circuits/repositories/circuits_repository.dart';
import 'package:f1_pet_project/core/results/constructor/repositories/constructor_catalog_repository.dart';
import 'package:f1_pet_project/core/results/driver/repositories/driver_catalog_repository.dart';
import 'package:f1_pet_project/router/app_router.gr.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class F1PetDeepLinkHandler extends StatefulWidget {
  const F1PetDeepLinkHandler({required this.forceUpdate, super.key});

  final bool forceUpdate;

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
    if (uri.pathSegments.isEmpty) {
      return;
    }

    final id = uri.pathSegments.first;
    if (id.isEmpty) {
      return;
    }

    switch (uri.host) {
      case 'driver':
        {
          final driver = await context.read<DriverCatalogRepository>().findByDriverId(id);
          if (driver == null || !mounted) {
            return;
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            context.router.push(DriverRoute(driver: driver));
          });
          break;
        }

      case 'constructor':
        {
          final constructor = await context.read<ConstructorCatalogRepository>().findByConstructorId(id);
          if (constructor == null || !mounted) {
            return;
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            context.router.push(ConstructorRoute(constructor: constructor));
          });
          break;
        }

      case 'circuit':
        {
          final circuit = await context.read<CircuitsRepository>().findByCircuitId(id);
          if (circuit == null || !mounted) {
            return;
          }

          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (!mounted) {
              return;
            }
            context.router.push(CircuitRoute(circuitModel: circuit));
          });
          break;
        }

      default:
        return;
    }
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
