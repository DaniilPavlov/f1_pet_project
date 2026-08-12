import 'package:flutter/material.dart';

/// Обёртка с анимацией нажатия и прыжка при выборе пункта навбара.
///
/// При выборе — scale-pulse через явный [AnimationController].
class BounceAnimationWidget extends StatefulWidget {
  const BounceAnimationWidget({required this.onPressed, required this.child, super.key, this.isSelected = false});

  final bool isSelected;
  final VoidCallback onPressed;
  final Widget child;

  @override
  State<BounceAnimationWidget> createState() => _BounceAnimationWidgetState();
}

/// Состояние анимаций нажатия, прыжка и pulse [BounceAnimationWidget].
class _BounceAnimationWidgetState extends State<BounceAnimationWidget> with TickerProviderStateMixin {
  final _isHover = ValueNotifier(false);
  final _offsetDuration = const Duration(milliseconds: 600);
  final _tapDuration = const Duration(milliseconds: 100);

  late final AnimationController _tapDownAnimationController;
  late final Animation<double> _scaleAnimation;

  late final AnimationController _jumpAnimationController;
  late final Animation<Offset> _jumpAnimation;

  late final AnimationController _selectPulseController;
  late final Animation<double> _selectPulse;

  @override
  void initState() {
    _tapDownAnimationController = AnimationController(vsync: this, duration: _tapDuration);
    // ignore: prefer_int_literals
    _scaleAnimation = Tween(begin: 1.0, end: 0.7).animate(_tapDownAnimationController);

    _jumpAnimationController = AnimationController(vsync: this, duration: _offsetDuration);
    _jumpAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(begin: Offset.zero, end: const Offset(0, -6)),
        weight: 0.25,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0, -6), end: const Offset(0, 6)),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0, 6), end: Offset.zero),
        weight: 0.25,
      ),
    ]).animate(CurvedAnimation(parent: _jumpAnimationController, curve: Curves.easeInOutCubic));

    _selectPulseController = AnimationController(vsync: this, duration: const Duration(milliseconds: 420));
    _selectPulse = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1, end: 1.18), weight: 0.45),
      TweenSequenceItem(tween: Tween(begin: 1.18, end: 1), weight: 0.55),
    ]).animate(CurvedAnimation(parent: _selectPulseController, curve: Curves.easeOutCubic));

    super.initState();
  }

  @override
  void dispose() {
    _isHover.dispose();
    _tapDownAnimationController.dispose();
    _jumpAnimationController.dispose();
    _selectPulseController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BounceAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      if (widget.isSelected) {
        _jumpAnimationController.forward(from: 0);
        _selectPulseController.forward(from: 0);
      } else {
        _jumpAnimationController.reverse();
        _selectPulseController.value = 0;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      child: MouseRegion(
        onEnter: (event) => _isHover.value = true,
        onExit: (event) => _isHover.value = false,
        child: GestureDetector(
          onTap: widget.onPressed,
          child: Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: _onTapDown,
            onPointerUp: _onTapUp,
            child: AnimatedBuilder(
              animation: Listenable.merge([_jumpAnimation, _selectPulse]),
              builder: (_, child) {
                return Transform.translate(
                  offset: _jumpAnimation.value,
                  child: Transform.scale(
                    scale: _selectPulse.value,
                    child: child,
                  ),
                );
              },
              child: ScaleTransition(scale: _scaleAnimation, child: widget.child),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapDown(PointerDownEvent _) {
    _tapDownAnimationController.forward();
  }

  void _onTapUp(PointerUpEvent _) {
    _tapDownAnimationController.reverse();
  }
}
