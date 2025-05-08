import 'package:flutter/material.dart';

class FloatingDragonBall extends StatelessWidget {
  final String imagePath;
  final double size;
  final double left;
  final double top;
  final Animation<double> animation;

  const FloatingDragonBall({
    super.key,
    required this.imagePath,
    required this.size,
    required this.left,
    required this.top,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return Positioned(
          left: left,
          top: top + animation.value,
          child: Image.asset(
            imagePath,
            width: size,
            height: size,
          ),
        );
      },
    );
  }
}