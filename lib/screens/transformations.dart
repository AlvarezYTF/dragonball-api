import 'package:flutter/material.dart';
import '../models/transformation.dart';
import '../services/transformacion_service.dart';
import '../widgets/dragonballs_loader.dart';
import '../widgets/card_transformaciones.dart'; // Asegúrate de que TransformacionCard esté aquí

// Corregida la ruta para Image.asset si es un asset local
const String logoUrl = 'assets/logo_dragonballapi.webp';

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
            const Text(
              'Transformaciones',
              style: TextStyle(color: Colors.black),
            ),
            const Spacer(),
            // Usar Image.asset si logoUrl es un asset local, como sugiere la ruta
            Image.asset(
              logoUrl,
              height: 40,
              fit: BoxFit.contain,
              // errorBuilder no es estándar para Image.asset, se usa para Image.network
              // Si es NetworkImage, la ruta '../assets/...' NO es correcta, debe ser una URL completa
              // Asumimos que es asset local y corregimos la carga
            ),
          ],
        ),
        // Si necesitas el botón de atrás, descomenta esto:
        // leading: IconButton(
        //   icon: const Icon(Icons.arrow_back, color: Colors.black),
        //   onPressed: () {
        //     Navigator.pop(context);
        //   },
        // ),
      ),
      body: FutureBuilder<List<Transformacion>>(
        future: _futureTransformaciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 150,
                // Duración ajustada a 7 segundos según tu último código
                child: DragonBallsLoader(duration: Duration(seconds: 7)),
              ),
            );
          } else if (snapshot.hasError) {
             // Manejo de error más amigable
             return Center(
               child: Padding(
                 padding: const EdgeInsets.all(16.0),
                 child: Column(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     const Icon(Icons.error_outline, color: Colors.red, size: 50),
                     const SizedBox(height: 10),
                     const Text(
                       'Error al cargar las transformaciones:',
                       textAlign: TextAlign.center,
                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                     ),
                     const SizedBox(height: 5),
                     Text(
                       '${snapshot.error}', // Muestra el detalle del error
                       textAlign: TextAlign.center,
                       style: const TextStyle(fontSize: 14, color: Colors.black54),
                     ),
                     const SizedBox(height: 20),
                     ElevatedButton(
                       onPressed: () {
                         // Opción para reintentar la carga
                         setState(() {
                           _futureTransformaciones = TransformacionService().fetchTransformaciones();
                         });
                       },
                       child: const Text('Reintentar'),
                     ),
                   ],
                 ),
               ),
             );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('No hay transformaciones disponibles.'),
            );
          }

          final transformaciones = snapshot.data!;
          // Tu última versión no tenía filtro de búsqueda, así que no se aplica aquí.

          return ColoredBox( // Añade un fondo ligero consistente con el AppBar
            color: Colors.grey[100]!,
            child: Column(
              children: [
                // Aquí podrías volver a añadir el SearchBarWidget si lo necesitas
                // ...

                // GridView con las transformaciones
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      // Puedes ajustar el breakpoint a tu gusto
                      final isDesktop = constraints.maxWidth > 900;
                      final crossAxisCount = isDesktop ? 4 : 2;
                      final childAspectRatio = isDesktop ? 0.85 : 0.75; // Más angosto en desktop

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
                          // Aquí simplemente usamos TransformacionCard.
                          // El efecto hover se implementará DENTRO de TransformacionCard.
                          return TransformacionCard(
                            transformacion: transformacion,
                            // Los parámetros width/height en GridView.builder no se usan así,
                            // el tamaño lo controla el childAspectRatio. Se remueven.
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