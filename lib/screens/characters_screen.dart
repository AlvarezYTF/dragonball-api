import 'package:flutter/material.dart';
import '../models/character.dart';
import '../services/api_service.dart';
import '../widgets/character_card.dart';

class CharactersScreen extends StatefulWidget {
  const CharactersScreen({super.key});

  @override
  State<CharactersScreen> createState() => _CharactersScreenState();
}

class _CharactersScreenState extends State<CharactersScreen> {
  late Future<List<Personaje>> _personajes;

  @override
  void initState() {
  super.initState();
  _personajes = ApiService().fetchAllCharacters();
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Personajes')),
      body: FutureBuilder<List<Personaje>>(
        future: _personajes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay personajes disponibles.'));
          }

          final personajes = snapshot.data!;
          return ListView.builder(
            itemCount: personajes.length,
            itemBuilder: (context, index) {
              return CharacterCard(personaje: personajes[index]);
            },
          );
        },
      ),
    );
  }
}
