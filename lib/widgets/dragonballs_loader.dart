import 'dart:math';
import 'package:flutter/material.dart';

class DragonBallsLoader extends StatefulWidget {
  final Duration duration; // duración opcional de la animación
  final VoidCallback? onFinish; // acción opcional al terminar

  const DragonBallsLoader({
    super.key,
    this.duration = const Duration(seconds: 7),
    this.onFinish,
  });

  @override
  State<DragonBallsLoader> createState() => _DragonBallsLoaderState();
}

class _DragonBallsLoaderState extends State<DragonBallsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 7),
    )..repeat();

    // Verifica que el widget esté montado antes de llamar a setState o stop
    Future.delayed(widget.duration, () {
      if (mounted) {
        _controller.stop();
        if (widget.onFinish != null) widget.onFinish!();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RotationTransition(
        turns: _controller,
        child: SizedBox(
          width: 150,
          height: 150,
          child: Stack(
            children: List.generate(7, (i) {
              final angle = (2 * pi / 7) * i;
              final radius = 50.0;
              return Positioned(
                left: 60 + radius * cos(angle),
                top: 60 + radius * sin(angle),
                child: Image.asset(
                  'assets/esferas_dragon/esfera_${i + 1}.png',
                  width: 30,
                  height: 30,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}
