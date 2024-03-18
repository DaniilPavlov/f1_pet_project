import 'package:flutter/material.dart';

/// Сам виджет, в котором происходим вся магия
class BounceAnimationWidget extends StatefulWidget {
  const BounceAnimationWidget({
    super.key,
    this.isSelected = false,
    required this.onPressed,
    required this.child,
  });

  final bool isSelected;
  final VoidCallback onPressed;
  final Widget child;

  @override
  State<BounceAnimationWidget> createState() => _BounceAnimationWidgetState();
}

class _BounceAnimationWidgetState extends State<BounceAnimationWidget>
    with TickerProviderStateMixin {
  final _isHover = ValueNotifier(false);
  final _offsetDuration = const Duration(milliseconds: 600);
  final _tapDuration = const Duration(milliseconds: 100);

  late final AnimationController _tapDownAnimationController;
  late final Animation<double> _scaleAnimation;

  late final AnimationController _jumpAnimationController;
  late final Animation<Offset> _jumpAnimation;

  @override
  void initState() {
    _tapDownAnimationController = AnimationController(
      vsync: this,
      duration: _tapDuration,
    );
    _scaleAnimation =
        Tween(begin: 1.0, end: 0.7).animate(_tapDownAnimationController);

    _jumpAnimationController = AnimationController(
      vsync: this,
      duration: _offsetDuration,
    );
    _jumpAnimation = TweenSequence<Offset>([
      TweenSequenceItem(
        tween: Tween<Offset>(begin: Offset.zero, end: const Offset(0, -6)),
        weight: 0.25,
      ),
      TweenSequenceItem(
        tween:
            Tween<Offset>(begin: const Offset(0, -6), end: const Offset(0, 6)),
        weight: 0.5,
      ),
      TweenSequenceItem(
        tween: Tween<Offset>(begin: const Offset(0, 6), end: Offset.zero),
        weight: 0.25,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _jumpAnimationController,
        curve: Curves.easeInOutCubic,
      ),
    );

    super.initState();
  }

  @override
  void dispose() {
    _isHover.dispose();
    _tapDownAnimationController.dispose();
    _jumpAnimationController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant BounceAnimationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isSelected != widget.isSelected) {
      widget.isSelected
          ? _jumpAnimationController.forward()
          : _jumpAnimationController.reverse();
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
              animation: _jumpAnimation,
              builder: (_, child) {
                return Transform.translate(
                  offset: _jumpAnimation.value,
                  child: child!,
                );
              },
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: widget.child,
              ),
            ),
          ),
        ),
      ),
    );
    // return ConstrainedBox(
    //   constraints: BoxConstraints.tight(const Size.square(46)),
    //   child: RepaintBoundary(
    //     child: MouseRegion(
    //       onEnter: (event) => _isHover.value = true,
    //       onExit: (event) => _isHover.value = false,
    //       child: GestureDetector(
    //         // behavior: HitTestBehavior.opaque,
    //         onTap: widget.onPressed,
    //         // Почему не GestureDetector? А все потому, что обратная анимация
    //         // при нажатии будет работать не совсем верно, а именно,
    //         // нажав на иконку и увести мышку с нее, потом отпустить - не сработает анимацию "назад"
    //         child: Listener(
    //           behavior: HitTestBehavior.opaque,
    //           onPointerDown: _onTapDown,
    //           onPointerUp: _onTapUp,
    //           child: Stack(
    //             fit: StackFit.expand,
    //             children: [
    //               // Небольшая оптимизация, при наведении на виджет не будет вызываться build на все дерево,
    //               // а только лишь на нужную нам часть
    //               ValueListenableBuilder<bool>(
    //                 valueListenable: _isHover,
    //                 builder: (_, value, __) => value || widget.isSelected
    //                     ? DecoratedBox(
    //                         decoration: BoxDecoration(
    //                           borderRadius: BorderRadius.circular(8),
    //                           color: Colors.white.withOpacity(0.2),
    //                         ),
    //                       )
    //                     : const SizedBox.shrink(),
    //               ),
    //               Align(
    //                 alignment: Alignment.bottomCenter,
    //                 child: AnimatedContainer(
    //                   duration: _duration,
    //                   curve: Curves.fastOutSlowIn,
    //                   height: 3.0,
    //                   width: widget.isSelected ? 16 : 6,
    //                   decoration: BoxDecoration(
    //                     borderRadius: const BorderRadius.all(Radius.circular(8.0)),
    //                     color: widget.isSelected ? colorScheme.primary : colorScheme.secondary,
    //                   ),
    //                 ),
    //               ),
    //               AnimatedBuilder(
    //                 animation: _jumpAnimation,
    //                 builder: (_, child) {
    //                   return Transform.translate(
    //                     offset: _jumpAnimation.value,
    //                     child: child!,
    //                   );
    //                 },
    //                 child: ScaleTransition(
    //                   scale: _scaleAnimation,
    //                   child: Padding(
    //                     padding: const EdgeInsets.all(10.0),
    //                     child: FittedBox(
    //                       fit: BoxFit.contain,
    //                       child: widget.child,
    //                     ),
    //                   ),
    //                 ),
    //               ),
    //             ],
    //           ),
    //         ),
    //       ),
    //     ),
    //   ),
    // );
  }

  /// Перехватчик нажатия на виджет, который запускает анимацию "прыжка" виджета при нажатии
  void _onTapDown(PointerDownEvent _) {
    _tapDownAnimationController.forward();
  }

  /// При отпускании кнопки на экране запускает в обратную сторону анимацию нажатия
  void _onTapUp(PointerUpEvent _) {
    _tapDownAnimationController.reverse();
  }
}
