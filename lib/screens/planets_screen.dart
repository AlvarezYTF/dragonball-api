import 'dart:math';
import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../services/planet_service.dart';
import '../widgets/search_bar.dart';
import 'planet_detail_screen.dart';

class PlanetsScreen extends StatefulWidget {
  const PlanetsScreen({super.key});

  @override
  State<PlanetsScreen> createState() => _PlanetsScreenState();
}

class _PlanetsScreenState extends State<PlanetsScreen>
    with SingleTickerProviderStateMixin {
  late Future<List<Planeta>> _planetas;
  late AnimationController _controlador;
  late Animation<double> _rotacion;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _planetas = PlanetService().getPlanets();
    _controlador = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
    _rotacion = Tween<double>(begin: 0, end: 2 * pi).animate(_controlador);
  }

  @override
  void dispose() {
    _controlador.dispose();
    super.dispose();
  }

  Widget _buildPlaneta(
    Planeta planeta,
    int index,
    int total,
    double radio,
    double centroX,
    double centroY,
  ) {
    return AnimatedBuilder(
      animation: _rotacion,
      builder: (context, child) {
        final angulo = 2 * pi * index / total + _rotacion.value;
        final x = radio * cos(angulo);
        final y = radio * sin(angulo);

        return Positioned(
          left: centroX + x - 30,
          top: centroY + y - 30,
          child: GestureDetector(
            onTap:
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlanetDetailScreen(planet: planeta),
                  ),
                ),
            child: Column(
              children: [
                ClipOval(
                  child: Image.network(
                    planeta.image,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  planeta.name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildEstrellasDecorativas(BoxConstraints constraints) {
    final posiciones = [
      const Offset(50, 80),
      const Offset(300, 100),
      const Offset(80, 400),
      const Offset(240, 600),
      const Offset(500, 300),
      const Offset(600, 120),
      const Offset(700, 500),
    ];

    return posiciones.map((pos) {
      return Positioned(
        left: pos.dx * constraints.maxWidth / 800,
        top: pos.dy * constraints.maxHeight / 800,
        child: const Icon(Icons.star, color: Colors.orangeAccent, size: 14),
      );
    }).toList();
  }

  Widget _buildLogo(BoxConstraints constraints) {
    return Positioned(
      top: constraints.maxHeight * 0.04,
      right: constraints.maxWidth * 0.04,
      child: SizedBox(
        width: constraints.maxWidth * 0.28,
        child: Column(
          children: [
            Image.asset('assets/logo_dragonballapi.webp', fit: BoxFit.contain),
            const Text(
              'The Dragon Ball API',
              style: TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCentroEsfera(double centroX, double centroY) {
    return AnimatedBuilder(
      animation: _rotacion,
      builder:
          (context, child) => Positioned(
            left: centroX - 40,
            top: centroY - 40,
            child: Transform.rotate(
              angle: _rotacion.value,
              child: Image.asset(
                'assets/images/logo_esfera.png',
                width: 80,
                height: 80,
                fit: BoxFit.contain,
              ),
            ),
          ),
    );
  }

  Widget _buildMensajeNoEncontrado() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            'assets/images/freezer.gif',
            width: 120,
            height: 120,
            fit: BoxFit.contain,
          ),
          const SizedBox(height: 8),
          Text(
            'No se encontró ningún planeta con el nombre "$_query"\nFreezer destruyó todo sobre este planeta.',
            style: const TextStyle(
              color: Colors.white70,
              fontStyle: FontStyle.italic,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Scaffold(
          backgroundColor: Colors.black,
          body: FutureBuilder<List<Planeta>>(
            future: _planetas,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final planetas = snapshot.data!;
              final filtrados =
                  _query.isEmpty
                      ? planetas
                      : planetas
                          .where((p) => p.name.toLowerCase().contains(_query))
                          .toList();
              final total = filtrados.length;
              final centroX = constraints.maxWidth / 2;
              final centroY = constraints.maxHeight / 2.15;
              final radio =
                  min(constraints.maxWidth, constraints.maxHeight) * 0.35;

              return Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/fondo_dragonball.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  ..._buildEstrellasDecorativas(constraints),
                  _buildLogo(constraints),
                  if (filtrados.isEmpty && _query.isNotEmpty)
                    _buildMensajeNoEncontrado()
                  else ...[
                    _buildCentroEsfera(centroX, centroY),
                    for (int i = 0; i < total; i++)
                      _buildPlaneta(
                        filtrados[i],
                        i,
                        total,
                        radio,
                        centroX,
                        centroY,
                      ),
                  ],
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: SearchBarWidget(
                      hintText: 'Buscar planeta',
                      onChanged:
                          (query) =>
                              setState(() => _query = query.toLowerCase()),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
