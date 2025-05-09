import 'package:flutter/material.dart';

class NavButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final Color startColor;
  final Color endColor;
  final double? width;  // Ancho personalizable
  final double height;  // Alto personalizable
  final EdgeInsetsGeometry padding; // Padding personalizable
  final double fontSize; // Tamaño de fuente personalizable
  final double iconSize; // Tamaño del icono personalizable

  const NavButton({
    super.key,
    required this.title,
    required this.onTap,
    this.startColor = const Color(0xFF000000),
    this.endColor = const Color(0xFF333333),
    this.width = 10,  // Puede ser null para adaptarse al contenido
    this.height = 60.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16.0),
    this.fontSize = 16.0,
    this.iconSize = 18.0,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: height,
        width: width, // Si es null, se adaptará al contenido
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [startColor, endColor],
          ),
          borderRadius: BorderRadius.circular(4),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: padding,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: Colors.white,
                size: iconSize,
              ),
            ],
          ),
        ),
      ),
    );
  }
}