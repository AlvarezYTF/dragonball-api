import 'package:flutter/material.dart';
import '../models/transformation.dart';
import '../services/transformacion_service.dart';
import '../widgets/dragonballs_loader.dart';
import '../widgets/card_transformaciones.dart';

const String logoUrl = '../assets/logo_dragonballapi.webp';

class TransformacionesScreen extends StatefulWidget {
  const TransformacionesScreen({super.key});

  @override
  State<TransformacionesScreen> createState() => _TransformacionesPageState();
}

class _TransformacionesPageState extends State<TransformacionesScreen> {
  late Future<List<Transformacion>> _futureTransformaciones;

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
            const Text('Transformaciones', style: TextStyle(color: Colors.black)),
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
                child: DragonBallsLoader(
                  duration: Duration(seconds: 7), // animación continua
                ),
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

          // Opción 1: Usar Column con un logo arriba y GridView abajo
          return Column(
            children: [
              // GridView con las transformaciones
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 cards por fila
                    childAspectRatio: 0.75, // Proporción de aspecto alto/ancho
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: transformaciones.length,
                  itemBuilder: (context, index) {
                    final transformacion = transformaciones[index];
                    return TransformacionCard(
                      transformacion: transformacion,
                      onTap: () {
                        // Aquí puedes agregar navegación a detalles si lo deseas
                        print('Seleccionado: ${transformacion.name}');
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
