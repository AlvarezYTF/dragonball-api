import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../services/planet_service.dart';
import '../widgets/planet_card.dart';

class PlanetsScreen extends StatefulWidget {
  const PlanetsScreen({super.key});

  @override
  State<PlanetsScreen> createState() => _PlanetsScreenState();
}

class _PlanetsScreenState extends State<PlanetsScreen> {
  late Future<List<Planeta>> _planets;

  @override
  void initState() {
    super.initState();
    _planets = PlanetService().getPlanets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEE6F2),
      appBar: AppBar(
        title: const Text('Planetas'),
        backgroundColor: const Color(0xFF1E1E2C),
      ),
      body: FutureBuilder<List<Planeta>>(
        future: _planets,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No se encontraron planetas'));
          }

          final planets = snapshot.data!;
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 220, // Cada tarjeta ocupa hasta este ancho
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 0.7,
            ),
            itemCount: planets.length,
            itemBuilder: (context, index) {
              return PlanetCard(planet: planets[index]);
            },
          );
        },
      ),
    );
  }
}
