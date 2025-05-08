import 'package:flutter/material.dart';
import '../models/character.dart';

class CharacterCard extends StatelessWidget {
  final Personaje personaje;

  const CharacterCard({super.key, required this.personaje});

   @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2C2C2C), // fondo oscuro
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Imagen
          Expanded(
            flex: 8,
            child: Container(
              padding: const EdgeInsets.all(10),
              child: Image.network(
                personaje.image,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Contenido inferior
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  personaje.name,
                  style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
                const SizedBox(height: 8),
                Text('Base KI:', style: TextStyle(color: Colors.grey[400])),
                Text(personaje.ki,
                    style: const TextStyle(color: Colors.amber)),
                const SizedBox(height: 4),
                Text('Total KI:', style: TextStyle(color: Colors.grey[400])),
                Text(personaje.maxKi,
                    style: const TextStyle(color: Colors.amber)),
                const SizedBox(height: 4),
                Text(
                  'Affiliation: ${personaje.affiliation}',
                  style: const TextStyle(color: Colors.amber),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}