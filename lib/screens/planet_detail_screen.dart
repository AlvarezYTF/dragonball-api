import 'package:flutter/material.dart';
import '../models/planet.dart';

class PlanetDetailScreen extends StatelessWidget {
  final Planeta planet;

  const PlanetDetailScreen({super.key, required this.planet});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(planet.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Image.network(planet.image, height: 200),
            const SizedBox(height: 20),
            Text(planet.description, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}