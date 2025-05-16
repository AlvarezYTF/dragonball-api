import 'package:flutter/material.dart';
import '../models/character.dart';

class CharacterDetailScreen extends StatelessWidget {
  final Personaje character;

  const CharacterDetailScreen({super.key, required this.character});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          character.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
            shadows: [
              Shadow(
                color: Color(0xB3000000),
                blurRadius: 10,
                offset: Offset(2, 2),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: SweepGradient(
            center: Alignment.center,
            colors: [
              Color(0xFF0F2027),
              Color(0xFF2C5364),
              Color(0xFF6A82FB),
              Color(0xFFFC5C7D),
              Color(0xFF0F2027),
            ],
            stops: [0.0, 0.25, 0.5, 0.75, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 80.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Imagen con efecto galáctico
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xAA6A82FB),
                          blurRadius: 60,
                          spreadRadius: 20,
                        ),
                        BoxShadow(
                          color: const Color(0x88FC5C7D),
                          blurRadius: 90,
                          spreadRadius: 30,
                        ),
                      ],
                      border: Border.all(
                        color: const Color(0xFF6A82FB),
                        width: 3,
                      ),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        character.image,
                        width: 220,
                        height: 220,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            width: 220,
                            height: 220,
                            color: const Color(0xFF232526),
                            child: const Center(
                              child: CircularProgressIndicator(
                                color: Color(0xFF6A82FB),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Descripción
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0x882C5364),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF6A82FB),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x885C258D),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Descripción',
                        style: TextStyle(
                          color: Color(0xFFFC5C7D),
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          shadows: [
                            Shadow(
                              color: Color(0xB3000000),
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        character.description,
                        style: const TextStyle(
                          fontSize: 18,
                          color: Color(0xE6FFFFFF),
                          fontWeight: FontWeight.w400,
                          height: 1.5,
                          shadows: [
                            Shadow(
                              color: Color(0xB3000000),
                              blurRadius: 5,
                              offset: Offset(1, 1),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),

                // Información
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0x882C5364),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: const Color(0xFF6A82FB),
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x885C258D),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Información',
                        style: TextStyle(
                          color: Color(0xFF6A82FB),
                          fontWeight: FontWeight.bold,
                          fontSize: 26,
                          shadows: [
                            Shadow(
                              color: Color(0xB3000000),
                              blurRadius: 5,
                              offset: Offset(2, 2),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      _buildInfoRow('Raza', character.race),
                      _buildInfoRow('Ki', character.ki),
                      _buildInfoRow('Ki Máximo', character.maxKi),
                      _buildInfoRow('Género', character.gender),
                      _buildInfoRow('Afiliación', character.affiliation),
                      _buildInfoRow(
                        'Planeta de origen',
                        character.originPlanet.name,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 16,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white70, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
