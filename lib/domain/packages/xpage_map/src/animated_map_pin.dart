import 'package:f1_pet_project/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class AnimatedMapPin extends StatefulWidget {
  const AnimatedMapPin({
    required this.isDragging,
    super.key,
  });

  final bool isDragging;

  @override
  State<AnimatedMapPin> createState() => _AnimatedMapPinState();
}

class _AnimatedMapPinState extends State<AnimatedMapPin>
    with TickerProviderStateMixin {
  late final AnimationController _controller;

  late final animation = Tween(
    begin: 0.0,
    end: 1.0,
  ).animate(
    CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    ),
  );

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant AnimatedMapPin oldWidget) {
    if (widget.isDragging) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (_, child) {
            return Transform.translate(
              offset: Offset(0, animation.value * -10),
              child: const Icon(
                Icons.location_on,
                color: Colors.red,
              ),
            );
          },
        ),
        Container(
          width: 10,
          height: 5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(180),
            // shape: BoxShape.circle,
            color: AppTheme.black.withOpacity(.5),
          ),
        ),
      ],
    );
  }
}
