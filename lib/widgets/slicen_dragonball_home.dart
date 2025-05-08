import 'dart:async';
import 'package:flutter/material.dart';

class FondoSlider extends StatefulWidget {
  const FondoSlider({super.key});

  @override
  State<FondoSlider> createState() => _FondoSliderState();
}

class _FondoSliderState extends State<FondoSlider> {
  final PageController _controller = PageController();
  int _currentPage = 0;
  late Timer _timer;

  final List<String> _imagenes = [
    'assets/images/slider1.webp',
    'assets/images/slider2.jpg',
    'assets/images/slider3.webp',
    'assets/images/slider4.webp',
    'assets/images/slider5.jpg',
    'assets/images/slider6.jpg',
  ];

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_currentPage < _imagenes.length - 1) {
        _currentPage++;
      } else {
        _currentPage = 0;
      }
      _controller.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: _controller,
      itemCount: _imagenes.length,
      itemBuilder: (context, index) {
        return Image.asset(
          _imagenes[index],
          fit: BoxFit.cover,
        );
      },
    );
  }
}