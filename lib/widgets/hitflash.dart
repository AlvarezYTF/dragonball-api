import 'package:flutter/material.dart';

class HitFlash extends StatefulWidget {
  final Offset position;
  final double size;
  final String imagePath;
  final Duration duration;

  const HitFlash({
    super.key,
    required this.position,
    required this.imagePath,
    this.size = 100,
    this.duration = const Duration(milliseconds: 300),
  });

  @override
  State<HitFlash> createState() => _HitFlashState();
}

class _HitFlashState extends State<HitFlash> {
  double opacity = 1.0;

  @override
  void initState() {
    super.initState();
    // Apaga el destello poco después de aparecer
    Future.delayed(const Duration(milliseconds: 50), () {
      if (mounted) setState(() => opacity = 0);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: widget.position.dx,
      top: widget.position.dy,
      child: AnimatedOpacity(
        duration: widget.duration,
        opacity: opacity,
        child: Image.asset(
          widget.imagePath,
          width: widget.size,
          height: widget.size,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}