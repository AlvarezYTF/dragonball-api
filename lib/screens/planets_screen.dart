import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../services/planet_service.dart';
import '../widgets/search_bar.dart';

class PlanetsScreen extends StatefulWidget {
  const PlanetsScreen({super.key});

  @override
  State<PlanetsScreen> createState() => _PlanetsScreenState();
}

class _PlanetsScreenState extends State<PlanetsScreen> {
  late Future<List<Planeta>> _planetFuture;
  List<Planeta> _filteredPlanets = [];
  String _currentQuery = '';

  @override
  void initState() {
    super.initState();
    _planetFuture = PlanetService().getAllPlanets();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Planetas Dragon Ball')),
      body: FutureBuilder<List<Planeta>>(
        future: _planetFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(), // O tu DragonBallsLoader
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error al cargar planetas: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay planetas disponibles.'));
          } else {
            final allPlanets = snapshot.data!;

            _filteredPlanets =
                _currentQuery.isEmpty
                    ? allPlanets
                    : allPlanets.where((planet) {
                      return planet.name.toLowerCase().contains(
                        _currentQuery.toLowerCase(),
                      );
                    }).toList();

            return Column(
              children: [
                SearchBarWidget(
                  hintText: 'Buscar planeta',
                  onChanged: (query) {
                    setState(() {
                      _currentQuery = query;
                      _filteredPlanets =
                          allPlanets.where((planet) {
                            return planet.name.toLowerCase().contains(
                              query.toLowerCase(),
                            );
                          }).toList();
                    });
                  },
                ),
                Expanded(
                  child:
                      _filteredPlanets.isEmpty
                          ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.grey,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'No se encontraron planetas relacionados con "${_currentQuery}"',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey,
                                    fontStyle: FontStyle.italic,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                          : ListView.builder(
                            itemCount: _filteredPlanets.length,
                            itemBuilder: (context, index) {
                              final planet = _filteredPlanets[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                child: ListTile(
                                  leading: Image.network(
                                    planet.image,
                                    width: 50,
                                    height: 50,
                                    fit: BoxFit.cover,
                                  ),
                                  title: Text(planet.name),
                                  subtitle: Text(planet.description),
                                ),
                              );
                            },
                          ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
