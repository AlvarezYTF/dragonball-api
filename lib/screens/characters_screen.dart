import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import '../widgets/character_card.dart';
import '../widgets/search_bar.dart';

const String logoUrl = 'assets/logo_dragonballapi.webp';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late Future<List<Personaje>> _personajes;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _personajes = ApiService().fetchAllCharacters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: Row(
          children: [
            const Text('Personajes', style: TextStyle(color: Colors.black)),
            const Spacer(), 
            Image.network(
              logoUrl,
              height: 40,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, color: Colors.red),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<List<Personaje>>(
          future: _personajes,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('No hay personajes disponibles.'),
              );
            }
            final personajes = snapshot.data!;
            final filtrados = _query.isEmpty
                ? personajes
                : personajes.where((p) => p.name.toLowerCase().contains(_query)).toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: SearchBarWidget(
                    hintText: 'Buscar personaje',
                    onChanged: (query) => setState(() => _query = query.toLowerCase()),
                  ),
                ),
                Expanded(
                  child: filtrados.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/zeno-sama.gif',
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No se encontró ningún personaje con el nombre "$_query"\nZeno-Sama acabo con este personaje.',
                                style: const TextStyle(
                                  color: Colors.black54,
                                  fontStyle: FontStyle.italic,
                                  fontSize: 14,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      : GridView.builder(
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.68,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                          ),
                          padding: const EdgeInsets.all(12),
                          itemCount: filtrados.length,
                          itemBuilder: (context, index) {
                            return CharacterCard(personaje: filtrados[index]);
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
