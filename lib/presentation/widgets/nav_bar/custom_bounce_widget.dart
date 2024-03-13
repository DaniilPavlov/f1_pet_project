import 'package:flutter/material.dart';

class CustomBounceWidget extends StatefulWidget {
  const CustomBounceWidget({
    super.key,
    required this.child,
    required this.onPressed,
    required this.isSelected,
    this.duration = const Duration(milliseconds: 200),
  });
  final Widget child;
  final VoidCallback onPressed;
  final Duration duration;
  final bool isSelected;

  @override
  State<CustomBounceWidget> createState() => _CustomBounceWidgetState();
}

class _CustomBounceWidgetState extends State<CustomBounceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _scale;
  final GlobalKey _childKey = GlobalKey();

  bool _isOutside = false;
  bool localSelected = false;

  Widget get child => widget.child;

  VoidCallback get onPressed => widget.onPressed;

  Duration get duration => widget.duration;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: duration,
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
    localSelected = widget.isSelected;
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CustomBounceWidget oldWidget) {
    if (oldWidget.isSelected && !widget.isSelected) {
      setState(() {
        localSelected = false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  void _onLongPressEnd(LongPressEndDetails details, BuildContext context) {
    final Offset touchPosition = details.globalPosition;

    if (!_isOutsideChildBox(touchPosition)) {
      onPressed();
      setState(
        () {
          localSelected = true;
        },
      );
    }
    _reverseAnimation();
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_isOutside) {
      onPressed();
      setState(
        () {
          localSelected = true;
        },
      );
    }
    _reverseAnimation();
  }

  void _onDragUpdate(DragUpdateDetails details, BuildContext context) {
    final Offset touchPosition = details.globalPosition;
    _isOutside = _isOutsideChildBox(touchPosition);
  }

  void _reverseAnimation() {
    if (mounted) {
      _controller.reverse();
    }
  }

  void _onTapDown(TapDownDetails details) {
    _controller.forward();
  }

  Future _onTap() async {
    await _controller.forward();
    onPressed();
    setState(
      () {
        localSelected = true;
      },
    );
    _reverseAnimation();
  }

  bool _isOutsideChildBox(Offset touchPosition) {
    final RenderBox? childRenderBox =
        _childKey.currentContext?.findRenderObject() as RenderBox?;
    if (childRenderBox == null) {
      return true;
    }
    final Size childSize = childRenderBox.size;
    final Offset childPosition = childRenderBox.localToGlobal(Offset.zero);

    return (touchPosition.dx < childPosition.dx ||
        touchPosition.dx > childPosition.dx + childSize.width ||
        touchPosition.dy < childPosition.dy ||
        touchPosition.dy > childPosition.dy + childSize.height);
  }

  @override
  Widget build(BuildContext context) {
    if (localSelected) {
      _scale = 1 - _controller.value;
    } else {
      _scale = _controller.value;
    }

    // TODO(pavlov): animation doesn't always work
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTapDown: _onTapDown,
        onTap: _onTap,
        onLongPressEnd: (details) => _onLongPressEnd(details, context),
        onHorizontalDragEnd: _onDragEnd,
        onVerticalDragEnd: _onDragEnd,
        onHorizontalDragUpdate: (details) => _onDragUpdate(details, context),
        onVerticalDragUpdate: (details) => _onDragUpdate(details, context),
        // scale animation
        child: localSelected
            ? Transform.scale(
                key: _childKey,
                scale: _scale,
                child: child,
              )
            :
            // jumping animation
            Transform.translate(
                key: _childKey,
                offset: Offset(0, -_scale * 70),
                child: child,
              ),
      ),
    );
  }
}
