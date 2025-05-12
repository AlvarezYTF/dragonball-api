import 'dart:math';
import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../screens/planet_detail_screen.dart';

class PlanetCard extends StatefulWidget {
  final Planeta planet;

  const PlanetCard({super.key, required this.planet});

  @override
  State<PlanetCard> createState() => _PlanetCardState();
}

class _PlanetCardState extends State<PlanetCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _orbitAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 10 + Random().nextInt(10)), // aleatoria
    )..repeat();

    _orbitAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlanetDetailScreen(planet: widget.planet),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E2C),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color.fromRGBO(0, 0, 0, 0.6),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Orbita animada
            AnimatedBuilder(
              animation: _orbitAnimation,
              builder: (context, child) {
                final angle = _orbitAnimation.value;
                final radius = 30.0;

                return Positioned(
                  left: 60 + radius * cos(angle),
                  top: 60 + radius * sin(angle),
                  child: ClipOval(
                    child: Image.network(
                      widget.planet.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),

            // Nombre
            Positioned(
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.planet.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
