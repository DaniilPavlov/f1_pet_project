import 'package:flutter/material.dart';

class CustomBounceWidget extends StatefulWidget {
  const CustomBounceWidget({
    super.key,
    required this.child,
    required this.onPressed,
    this.scaleFactor = 1,
    this.duration = const Duration(milliseconds: 200),
  });
  final Widget child;
  final VoidCallback onPressed;
  final double scaleFactor;
  final Duration duration;

  @override
  State<CustomBounceWidget> createState() => _CustomBounceWidgetState();
}

class _CustomBounceWidgetState extends State<CustomBounceWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _scale;
  final GlobalKey _childKey = GlobalKey();

  bool _isOutside = false;

  Widget get child => widget.child;

  VoidCallback get onPressed => widget.onPressed;

  double get scaleFactor => widget.scaleFactor;

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

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLongPressEnd(LongPressEndDetails details, BuildContext context) {
    final Offset touchPosition = details.globalPosition;

    if (!_isOutsideChildBox(touchPosition)) {
      onPressed();
    }

    _reverseAnimation();
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_isOutside) {
      onPressed();
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

  void _onTapUp(TapUpDetails details) {
    _reverseAnimation();
    onPressed();
  }

  Future _onTap() async {
    await _controller.forward();
    _reverseAnimation();
    onPressed();
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
    _scale = 1 - (_controller.value * scaleFactor);

    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: _onTap,
      onLongPressEnd: (details) => _onLongPressEnd(details, context),
      onHorizontalDragEnd: _onDragEnd,
      onVerticalDragEnd: _onDragEnd,
      onHorizontalDragUpdate: (details) => _onDragUpdate(details, context),
      onVerticalDragUpdate: (details) => _onDragUpdate(details, context),
      // scale animation
      child: Transform.scale(
        key: _childKey,
        scale: _scale,
        child: child,
      ),
    );
  }
}

class CustomBounceWidget2 extends StatefulWidget {
  const CustomBounceWidget2({
    super.key,
    required this.child,
    required this.onPressed,
    this.scaleFactor = 1,
    this.duration = const Duration(milliseconds: 200),
  });
  final Widget child;
  final VoidCallback onPressed;
  final double scaleFactor;
  final Duration duration;

  @override
  State<CustomBounceWidget2> createState() => _CustomBounceWidget2State();
}

class _CustomBounceWidget2State extends State<CustomBounceWidget2>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _scale;
  final GlobalKey _childKey = GlobalKey();

  bool _isOutside = false;

  Widget get child => widget.child;

  VoidCallback get onPressed => widget.onPressed;

  double get scaleFactor => widget.scaleFactor;

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

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onLongPressEnd(LongPressEndDetails details, BuildContext context) {
    final Offset touchPosition = details.globalPosition;

    if (!_isOutsideChildBox(touchPosition)) {
      onPressed();
    }

    _reverseAnimation();
  }

  void _onDragEnd(DragEndDetails details) {
    if (!_isOutside) {
      onPressed();
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

  void _onTapUp(TapUpDetails details) {
    _reverseAnimation();
    onPressed();
  }

  Future _onTap() async {
    await _controller.forward();
    _reverseAnimation();
    onPressed();
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
    _scale = _controller.value * scaleFactor;
    debugPrint((_scale - _controller.value).toString());
    return GestureDetector(
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTap: _onTap,
      onLongPressEnd: (details) => _onLongPressEnd(details, context),
      onHorizontalDragEnd: _onDragEnd,
      onVerticalDragEnd: _onDragEnd,
      onHorizontalDragUpdate: (details) => _onDragUpdate(details, context),
      onVerticalDragUpdate: (details) => _onDragUpdate(details, context),
      // jumping animation
      child: Transform.translate(
        key: _childKey,
        offset: Offset(0, -_scale * 70),
        child: child,
      ),
    );
  }
}
