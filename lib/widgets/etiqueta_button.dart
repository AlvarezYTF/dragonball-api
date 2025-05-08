import 'package:flutter/material.dart';

class EtiquetaButton extends StatelessWidget {
  final String texto;
  final Color colorFondo;
  final Color colorTexto;
  final VoidCallback onTap;

  const EtiquetaButton({
    super.key,
    required this.texto,
    required this.colorFondo,
    required this.colorTexto,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: colorFondo,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Text(
          texto,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: colorTexto,
          ),
        ),
      ),
    );
  }
}