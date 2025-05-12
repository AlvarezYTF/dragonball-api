import 'package:flutter/material.dart';
import '../models/transformation.dart';

class TransformacionCard extends StatefulWidget {
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
  State<TransformacionCard> createState() => _TransformacionCardState();
}

class _TransformacionCardState extends State<TransformacionCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        height: 300,
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
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: MouseRegion(
                    onEnter: (_) => setState(() => isHovered = true),
                    onExit: (_) => setState(() => isHovered = false),
                    child: AnimatedScale(
                      scale: isHovered ? 1.1 : 1.0,
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      child: Image.network(
                        widget.transformacion.image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[900],
                            child: const Center(
                              child: Icon(Icons.error_outline,
                                  size: 40, color: Colors.white54),
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
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.transformacion.name,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Base KI: ${widget.transformacion.ki}',
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
