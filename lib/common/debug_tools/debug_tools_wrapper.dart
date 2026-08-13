import 'package:f1_pet_project/common/debug_tools/debug_tools_controller.dart';
import 'package:f1_pet_project/common/debug_tools/debug_tools_helper.dart';
import 'package:f1_pet_project/common/debug_tools/talker_repository.dart';
import 'package:f1_pet_project/common/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:inspector/inspector.dart';
import 'package:provider/provider.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Overlay с перетаскиваемой кнопкой «глазик»: inspector + talker.
///
/// В release не монтируется (см. [DebugToolsHelper.isEnabled]).
///
/// [navigatorKey] нужен для Talker: кнопки живут в `MaterialApp.builder`
/// снаружи Navigator, поэтому `Navigator.of(context)` недоступен.
class DebugToolsWrapper extends StatelessWidget {
  const DebugToolsWrapper({
    required this.child,
    required this.navigatorKey,
    super.key,
  });

  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  @override
  Widget build(BuildContext context) {
    if (!DebugToolsHelper.isEnabled) {
      return child;
    }

    return Consumer<DebugToolsController>(
      builder: (context, controller, _) {
        return Stack(
          fit: StackFit.expand,
          children: [
            Inspector(
              isEnabled: controller.inspectorVisible,
              isPanelVisible: controller.inspectorVisible,
              child: child,
            ),
            if (controller.inspectorVisible)
              Positioned(
                right: 16,
                bottom: 96,
                child: _TalkerButton(navigatorKey: navigatorKey),
              ),
            const _EyeButton(),
          ],
        );
      },
    );
  }
}

class _EyeButton extends StatefulWidget {
  const _EyeButton();

  @override
  State<_EyeButton> createState() => _EyeButtonState();
}

class _EyeButtonState extends State<_EyeButton> {
  RenderBox? _renderBox;
  Size? _bounds;

  @override
  Widget build(BuildContext context) {
    return Overlay(
      initialEntries: [
        OverlayEntry(
          builder: (context) => SafeArea(
            maintainBottomViewPadding: true,
            child: Builder(
              builder: (context) {
                if (_bounds == null || _renderBox == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (!mounted) {
                      return;
                    }
                    setState(() {
                      _bounds = context.size;
                      _renderBox = context.findRenderObject() as RenderBox?;
                    });
                  });
                }

                return Stack(
                  children: [
                    Consumer<DebugToolsController>(
                      builder: (context, controller, _) {
                        if (!controller.positionReady) {
                          return const SizedBox.shrink();
                        }

                        final button = FloatingActionButton.small(
                          heroTag: 'f1_debug_eye',
                          backgroundColor: AppTheme.red,
                          foregroundColor: AppTheme.onChrome,
                          elevation: 4,
                          onPressed: controller.toggleInspector,
                          child: Icon(
                            controller.inspectorVisible
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        );

                        return Positioned(
                          left: _clampAxis(0, _bounds?.width, controller.buttonOffset.dx, 48),
                          top: _clampAxis(0, _bounds?.height, controller.buttonOffset.dy, 48),
                          child: Draggable(
                            feedback: button,
                            childWhenDragging: const SizedBox.shrink(),
                            onDragEnd: (details) {
                              final box = _renderBox;
                              if (box == null) {
                                return;
                              }
                              controller.writePosition(box.globalToLocal(details.offset));
                            },
                            child: button,
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  double _clampAxis(double? min, double? max, double start, double length) {
    if (min == null || max == null) {
      return start;
    }
    if (start < min) {
      return min;
    }
    if (start + length > max) {
      return max - length;
    }
    return start;
  }
}

class _TalkerButton extends StatefulWidget {
  const _TalkerButton({required this.navigatorKey});

  final GlobalKey<NavigatorState> navigatorKey;

  @override
  State<_TalkerButton> createState() => _TalkerButtonState();
}

class _TalkerButtonState extends State<_TalkerButton> {
  var _visible = true;

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);

    return FloatingActionButton.small(
      heroTag: 'f1_debug_talker',
      backgroundColor: AppTheme.chrome,
      foregroundColor: AppTheme.onChrome,
      elevation: 4,
      onPressed: () {
        final navigator = widget.navigatorKey.currentState;
        if (navigator == null) {
          return;
        }
        setState(() => _visible = false);
        navigator
            .push(
              MaterialPageRoute<void>(
                builder: (_) => TalkerScreen(
                  talker: TalkerRepository.talker,
                  isLogsExpanded: false,
                  theme: TalkerScreenTheme(
                    backgroundColor: theme.colorScheme.surface,
                    textColor: theme.colorScheme.onSurface,
                    cardColor: theme.colorScheme.surfaceContainerHighest,
                  ),
                ),
              ),
            )
            .whenComplete(() {
              if (mounted) {
                setState(() => _visible = true);
              }
            });
      },
      child: const Icon(Icons.receipt_long_outlined),
    );
  }
}
