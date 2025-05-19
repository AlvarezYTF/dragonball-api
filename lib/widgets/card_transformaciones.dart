// Archivo: lib/widgets/card_transformaciones.dart
import 'package:flutter/material.dart';
import '../models/transformation.dart';

// Sigue siendo un StatefulWidget para manejar el estado del hover
class TransformacionCard extends StatefulWidget {
  final Transformacion transformacion;
  final VoidCallback? onTap;

  const TransformacionCard({
    super.key,
    required this.transformacion,
    this.onTap,
  });

  @override
  _TransformacionCardState createState() => _TransformacionCardState();
}

class _TransformacionCardState extends State<TransformacionCard> {
  bool _isHovering = false;
  final Duration _duration = const Duration(milliseconds: 200); // Duración de la animación
  final double _imageScale = 1.25; // Factor de zoom para la imagen (ajusta para que sobresalga más)
  final double _imageVerticalOffset = 25; // Cuánto se moverá la imagen hacia arriba al hacer hover (en píxeles)

  void _setHovering(bool isHovering) {
    if (_isHovering != isHovering) {
      setState(() {
        _isHovering = isHovering;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Estimamos la altura necesaria para la sección de texto y padding en la parte inferior del card
    // Este valor puede necesitar ajuste dependiendo del tamaño de fuente y padding exactos
    const double estimatedTextSectionHeight = 60; // Altura estimada en píxeles

    // Envolver el contenido principal con MouseRegion y GestureDetector
    return MouseRegion(
      onEnter: (_) => _setHovering(true), // Detectar entrada del ratón
      onExit: (_) => _setHovering(false), // Detectar salida del ratón
      child: GestureDetector( // Detectar taps
        onTap: widget.onTap,
        child: Card(
          elevation: _isHovering ? 12 : 6, // Cambia la elevación al hacer hover
          color: Colors.black.withAlpha(178), // Color del card
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          // *** CRUCIAL: Permitir que el contenido (la imagen) se salga de los límites del Card ***
          clipBehavior: Clip.none, // <--- Cambiado de Clip.antiAlias a Clip.none

          // Usamos un Stack para poner la imagen y el texto en capas separadas
          child: Stack(
            clipBehavior: Clip.none, // Permitir que los hijos del Stack sobresalgan
            alignment: Alignment.topCenter, // Alinear hijos desde la parte superior por defecto

            children: [
               // --- El contenido NO-imagen (texto y fondo del card) ---
               // Este Container da la forma del card. El texto se posiciona dentro.
               Container(
                 decoration: BoxDecoration(
                    color: Colors.black.withAlpha(178), // Color de fondo si el Stack necesita uno
                    borderRadius: BorderRadius.circular(20), // Mismos bordes del card
                 ),
                 // Usamos un Column para que el espacio Expanded empuje el texto hacia abajo
                 child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Espacio flexible para la imagen arriba (invisible)
                      Expanded(child: Container()),

                      // La sección de detalles de la transformación (Nombre, Ki, etc.)
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
                               maxLines: 1,
                               overflow: TextOverflow.ellipsis,
                             ),
                             const SizedBox(height: 4),
                             Text(
                               'Base KI: ${widget.transformacion.ki}',
                               style: const TextStyle(color: Colors.yellowAccent),
                               maxLines: 1,
                               overflow: TextOverflow.ellipsis,
                             ),
                           ],
                         ),
                       ),
                    ],
                 ),
               ),

              // --- La imagen del personaje (posicionada encima y animada) ---
              // Posicionamos la imagen en el área superior.
              Positioned(
                 top: 0,
                 left: 0,
                 right: 0,
                 // La parte inferior de la imagen se define relative a la altura del texto estimado.
                 // Esto necesita ajuste si la altura real del texto varía.
                 bottom: estimatedTextSectionHeight, // Position bottom edge just above text section

                 child: AnimatedScale( // Aplicar escala animation
                   scale: _isHovering ? _imageScale : 1.0,
                   duration: _duration,
                   curve: Curves.easeInOut,
                   // *** CORREGIDO: Reemplazar AnimatedSlide con TweenAnimationBuilder + Transform.translate ***
                   child: TweenAnimationBuilder<Offset>( // Animar el offset de traslación
                     tween: Tween<Offset>(
                       begin: Offset.zero, // Inicia en la posición normal
                       end: _isHovering ? Offset(0, -_imageVerticalOffset) : Offset.zero, // Mueve hacia arriba por la cantidad de píxeles definida
                     ),
                     duration: _duration, // Usar la duración de la animación general
                     curve: Curves.easeInOut, // Usar la misma curva de animación
                     builder: (context, offset, child) {
                       return Transform.translate( // Aplica la traslación a la imagen
                         offset: offset, // Usar el valor de offset animado
                         child: child!, // El hijo (Center -> Image.network) se pasa aquí
                       );
                     },
                     // El child de TweenAnimationBuilder es el widget que se animará
                     child: Center( // Centrar la imagen horizontalmente en su área
                       child: Image.network(
                         widget.transformacion.image,
                         fit: BoxFit.contain, // Usar contain para que el personaje completo sea visible
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
                 ),
              ),

               // --- Capa transparente para capturar el hover en toda el área del card ---
               // Esto asegura que el MouseRegion detecte el hover aunque el ratón no esté directamente sobre la imagen
               Positioned.fill(child: Container(color: Colors.transparent)),

            ],
          ),
        ),
      ),
    );
  }
}