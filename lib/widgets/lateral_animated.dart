import 'dart:async';
import 'package:flutter/material.dart';

class LateralAnimatedImage extends StatefulWidget {
  final List<String> imagePaths;
  final double width;
  final Duration interval;

  const LateralAnimatedImage({
    super.key,
    required this.imagePaths,
    this.width = 100,
    this.interval = const Duration(seconds: 10),
  });

  @override
  State<LateralAnimatedImage> createState() => _LateralAnimatedImageState();
}

class _LateralAnimatedImageState extends State<LateralAnimatedImage> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(widget.interval, (timer) {
      setState(() {
        _currentIndex = (_currentIndex + 1) % widget.imagePaths.length;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      widget.imagePaths[_currentIndex],
      width: widget.width,
    );
  }
}