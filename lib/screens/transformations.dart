import 'package:flutter/material.dart';
import '../models/transformation.dart';
import '../services/transformacion_service.dart';
import '../widgets/dragonballs_loader.dart';
import '../widgets/card_transformaciones.dart';
import 'transformations_detail.dart';

const String logoUrl = '../assets/logo_dragonballapi.webp';

class TransformacionesScreen extends StatefulWidget {
  const TransformacionesScreen({super.key});

  @override
  State<TransformacionesScreen> createState() => _TransformacionesPageState();
}

class _TransformacionesPageState extends State<TransformacionesScreen> {
  late Future<List<Transformacion>> _futureTransformaciones;

  // 🔥 Set para controlar los índices con hover o tap
  final Set<int> _hoveredIndexes = {};

  @override
  void initState() {
    super.initState();
    _futureTransformaciones = TransformacionService().fetchTransformaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey[300],
        elevation: 0,
        title: Row(
          children: [
            const Text(
              'Transformaciones',
              style: TextStyle(color: Colors.black),
            ),
            const Spacer(),
            Image.network(
              logoUrl,
              height: 40,
              fit: BoxFit.contain,
              errorBuilder:
                  (context, error, stackTrace) =>
                      const Icon(Icons.error, color: Colors.red),
            ),
          ],
        ),
      ),
      body: FutureBuilder<List<Transformacion>>(
        future: _futureTransformaciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 150,
                child: DragonBallsLoader(duration: Duration(seconds: 7)),
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay transformaciones disponibles.'),
            );
          }

          final transformaciones = snapshot.data!;

          return Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isDesktop = constraints.maxWidth > 900;
                    final crossAxisCount = isDesktop ? 4 : 2;
                    final childAspectRatio = isDesktop ? 0.85 : 0.75;

                    return GridView.builder(
                      padding: const EdgeInsets.all(8),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: childAspectRatio,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemCount: transformaciones.length,
                      itemBuilder: (context, index) {
                        final transformacion = transformaciones[index];
                        final isHovered = _hoveredIndexes.contains(index);

                        return GestureDetector(
                          onTap: () {
                            final related =
                                transformaciones
                                    .where(
                                      (t) =>
                                          t.personajeId ==
                                              transformacion.personajeId &&
                                          t.id != transformacion.id,
                                    )
                                    .toList();
                            showModalBottomSheet(
                              context: context,
                              builder:
                                  (_) => TransformationDetailModal(
                                    transformacion: transformacion,
                                    relatedTransformations: related,
                                  ),
                            );
                          },
                          child: MouseRegion(
                            onEnter: (_) {
                              setState(() {
                                _hoveredIndexes.add(index);
                              });
                            },
                            onExit: (_) {
                              setState(() {
                                _hoveredIndexes.remove(index);
                              });
                            },
                            child: AnimatedScale(
                              scale: isHovered ? 1.1 : 1.0,
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                              child: TransformacionCard(
                                transformacion: transformacion,
                                width: isDesktop ? 180 : null,
                                height: isDesktop ? 260 : null,
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
