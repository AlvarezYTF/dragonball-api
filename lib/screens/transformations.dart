import 'package:flutter/material.dart';
import '../models/transformation.dart';
import '../services/transformacion_service.dart';

class TransformacionesPage extends StatefulWidget {
  const TransformacionesPage({super.key});

  @override
  State<TransformacionesPage> createState() => _TransformacionesPageState();
}

class _TransformacionesPageState extends State<TransformacionesPage> {
  late Future<List<Transformacion>> _futureTransformaciones;

  @override
  void initState() {
    super.initState();
    _futureTransformaciones = TransformacionService().fetchTransformaciones();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Transformaciones')),
      body: FutureBuilder<List<Transformacion>>(
        future: _futureTransformaciones,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay transformaciones disponibles.'));
          }

          final transformaciones = snapshot.data!;

          return ListView.builder(
            itemCount: transformaciones.length,
            itemBuilder: (context, index) {
              final t = transformaciones[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  leading: Image.network(t.image, width: 50, fit: BoxFit.cover),
                  title: Text(t.name),
                  subtitle: Text('Ki: ${t.ki}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}