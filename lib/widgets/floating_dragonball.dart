import 'package:flutter/material.dart';

class FloatingDragonBall extends StatelessWidget {
  final String imagePath;
  final double size; // proporción respecto a imgWidth
  final Animation<double> animation;

  const FloatingDragonBall({
    super.key,
    required this.imagePath,
    required this.size,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (_, __) {
        return Transform.translate(
          offset: Offset(0, animation.value),
          child: Image.asset(imagePath, width: size, height: size),
        );
      },
    );
  }
}
