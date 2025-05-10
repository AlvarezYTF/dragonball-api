import 'package:flutter/material.dart';
import '../models/transformation.dart';

class TransformacionCard extends StatelessWidget {
  final Transformacion transformacion;
  final VoidCallback? onTap;
  final double? width;
  final double? height;

  const TransformacionCard({
    super.key,
    required this.transformacion,
    this.onTap,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 300, // Ajusta la altura según necesites
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Card(
          color: Colors.black.withAlpha(178),
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                  child: Image.network(
                    transformacion.image,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: Icon(Icons.error_outline, size: 40, color: Colors.white54),
                        ),
                      );
                    },
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return Center(
                        child: CircularProgressIndicator(
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transformacion.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Base KI: ${transformacion.ki}',
                      style: const TextStyle(color: Colors.yellowAccent),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}