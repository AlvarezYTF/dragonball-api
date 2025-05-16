import 'package:flutter/material.dart';
import '../models/transformation.dart';
import '../services/transformacion_service.dart';
import '../widgets/dragonballs_loader.dart';
import '../widgets/card_transformaciones.dart';
import '../widgets/search_bar.dart';

const String logoUrl = '../assets/logo_dragonballapi.webp';

class TransformacionesScreen extends StatefulWidget {
  const TransformacionesScreen({super.key});

  @override
  State<TransformacionesScreen> createState() => _TransformacionesPageState();
}

class _TransformacionesPageState extends State<TransformacionesScreen> {
  late Future<List<Transformacion>> _futureTransformaciones;
  String _query = '';

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
              errorBuilder: (context, error, stackTrace) =>
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
          final filtradas = _query.isEmpty
              ? transformaciones
              : transformaciones
                  .where((t) => t.name.toLowerCase().contains(_query))
                  .toList();

          return ColoredBox(
            color: Colors.grey[100]!,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SearchBarWidget(
                    hintText: 'Buscar transformación',
                    onChanged: (query) => setState(() => _query = query.toLowerCase()),
                  ),
                ),
                Expanded(
                  child: filtradas.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                'assets/images/majinbuu.gif',
                                width: 120,
                                height: 120,
                                fit: BoxFit.contain,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'No se encontró ninguna transformación con el nombre "$_query"\nMajin buu acabo con esta trasnformación.',
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
                      : LayoutBuilder(
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
                              itemCount: filtradas.length,
                              itemBuilder: (context, index) {
                                final transformacion = filtradas[index];
                                return TransformacionCard(
                                  transformacion: transformacion,
                                  width: isDesktop ? 180 : null,
                                  height: isDesktop ? 260 : null,
                                );
                              },
                            );
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
