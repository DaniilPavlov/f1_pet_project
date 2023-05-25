import 'package:flutter/material.dart';

/// Дефолтный закругленный контейнер
class RoundedContainer extends StatelessWidget {
  final Widget child;
  final double? height;
  final double? width;
  final double borderRadius;
  final Color backgroundColor;
  final VoidCallback? onTap;

  /// По-дефолту EdgeInsets.zero, т.к. у всех контейнеров свой паддинг
  final EdgeInsets contentPadding;

  final EdgeInsets margin;

  const RoundedContainer({
    required this.child,
    this.borderRadius = 20,
    this.backgroundColor = Colors.white,
    this.contentPadding = EdgeInsets.zero,
    this.margin = EdgeInsets.zero,
    this.width,
    this.height,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // TODO(all): сюда нужно добавить возможность добавления бордера
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.hardEdge,
      child: Material(
        color: backgroundColor,
        child: InkWell(
          onTap: onTap,
          child: Container(
            height: height,
            width: width,
            margin: margin,
            clipBehavior: Clip.none,
            padding: contentPadding,
            color: Colors.transparent,
            child: child,
          ),
        ),
      ),
    );
  }
}
