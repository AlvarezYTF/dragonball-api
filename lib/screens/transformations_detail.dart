import 'package:flutter/material.dart';
import '../models/transformation.dart';

class TransformationDetailModal extends StatelessWidget {
  final Transformacion transformacion;
  final List<Transformacion> relatedTransformations;

  const TransformationDetailModal({
    super.key,
    required this.transformacion,
    required this.relatedTransformations,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              Center(
                child: Image.network(
                  transformacion.image,
                  height: 160,
                  errorBuilder: (_, __, ___) => const Icon(Icons.error),
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: Text(
                  transformacion.name,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 8),
              Center(child: Text('Ki: ${transformacion.ki}')),
              const SizedBox(height: 20),
              const Text('Transformaciones relacionadas:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: relatedTransformations.length,
                itemBuilder: (context, index) {
                  final t = relatedTransformations[index];
                  return ListTile(
                    leading: Image.network(t.image, width: 40, errorBuilder: (_, __, ___) => const Icon(Icons.error)),
                    title: Text(t.name),
                    subtitle: Text('Ki: ${t.ki}'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}