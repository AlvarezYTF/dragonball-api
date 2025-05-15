import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../models/character.dart';
import '../services/planet_service.dart';
import 'character_detail_screen.dart';

class PlanetDetailScreen extends StatefulWidget {
  final Planeta planet;
  const PlanetDetailScreen({Key? key, required this.planet}) : super(key: key);
  @override
  State<PlanetDetailScreen> createState() => _PlanetDetailScreenState();
}

class _PlanetDetailScreenState extends State<PlanetDetailScreen> {
  late Future<Planeta> _planetDetailsFuture;
  final _planetService = PlanetService();

  @override
  void initState() {
    super.initState();
    _planetDetailsFuture = _planetService.getPlanetDetails(widget.planet.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.planet.name)),
      body: FutureBuilder<Planeta>(
        future: _planetDetailsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return const Center(
              child: Text('No se encontraron datos del planeta'),
            );
          }

          final planet = snapshot.data!;

          // Obtener personajes del planeta (sin filtrar, la API ya lo hace)
          final characteresDelPlaneta =
              planet.characters
                  .map((charData) => Personaje.fromJson(charData))
                  .toList();

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Image.network(
                      planet.image,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Descripción',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    planet.description,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  if (characteresDelPlaneta.isNotEmpty) ...[
                    Text(
                      'Personajes Originarios',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 150,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: characteresDelPlaneta.length,
                        itemBuilder: (context, index) {
                          final character = characteresDelPlaneta[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) => CharacterDetailScreen(
                                          character: character,
                                        ),
                                  ),
                                );
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      character.image,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      character.name,
                                      textAlign: TextAlign.center,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ] else
                    const Text(
                      'No hay personajes originarios de este planeta.',
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
