import 'package:flutter/material.dart';
import '../models/transformation.dart'; // Asegúrate de que este modelo exista y tenga 'name', 'image', 'ki'

class TransformacionCard extends StatefulWidget {
  final Transformacion transformacion;
  final VoidCallback? onTap;
  // Puedes mantener o eliminar estos parámetros si tu diseño de tarjeta no los usa
  // final double? width;
  // final double? height;

  const TransformacionCard({
    super.key,
    required this.transformacion,
    this.onTap,
    // this.width,
    // this.height,
  });

  @override
  _TransformacionCardState createState() => _TransformacionCardState();
}

class _TransformacionCardState extends State<TransformacionCard> {
  bool _isHoveringImage = false; // Estado para el hover sobre la imagen

  // Factor de escala para el zoom de la imagen al hacer hover
  final double _imageHoverScale = 1.2; // Ajusta este valor para el zoom de la imagen
  // Desplazamiento vertical de la imagen al hacer hover (valor negativo para mover hacia arriba)
  final double _imageHoverVerticalOffset = -30.0; // Ajusta este valor para controlar cuánto "sale" la imagen
  // Duración de la animación de zoom y desplazamiento
  final Duration _zoomDuration = const Duration(milliseconds: 200);

  // Método para actualizar el estado de hover de la imagen.
  void _setHoveringImage(bool isHovering) {
    if (_isHoveringImage != isHovering) {
      setState(() {
        _isHoveringImage = isHovering;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector( // Mantenemos GestureDetector para el onTap si lo necesitas
      onTap: widget.onTap,
      child: Container(
        // La altura del Container padre puede necesitar ajuste dependiendo del GridView
        // height: 300, // Considera si esta altura fija es adecuada en todos los casos
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6), // Ajustado el margen ligeramente
        child: Card(
          color: Colors.black.withAlpha(178), // Color de fondo de la tarjeta
          elevation: 8, // Sombra de la tarjeta
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Bordes redondeados
          ),
          // Usamos Clip.none para permitir que la imagen salga del Card
          clipBehavior: Clip.none, // Crucial para que la imagen "salga"

          child: Stack( // Usamos Stack para superponer la imagen y el texto
            // Alineación del Stack. Puede ajustarse si es necesario.
            alignment: Alignment.bottomCenter,
            children: [
              // Área de la imagen con detección de hover, animación de zoom y desplazamiento
              Positioned( // Posiciona la imagen dentro del Stack
                // La posición top se ajusta con el desplazamiento al hacer hover
                top: _isHoveringImage ? _imageHoverVerticalOffset : 0.0,
                left: 0,
                right: 0,
                // La altura será determinada por el AspectRatio y el espacio disponible
                child: MouseRegion( // Detecta eventos de puntero sobre la imagen
                  onEnter: (_) => _setHoveringImage(true), // Cuando el puntero entra
                  onExit: (_) => _setHoveringImage(false), // Cuando el puntero sale
                  child: AnimatedScale( // Aplica la animación de escala a la imagen
                    scale: _isHoveringImage ? _imageHoverScale : 1.0, // Factor de zoom de la imagen
                    duration: _zoomDuration, // Duración de la animación
                    curve: Curves.easeInOut, // Curva de la animación
                    child: AspectRatio( // Mantiene la proporción de la imagen
                       // Ajusta este valor si las imágenes tienen una proporción diferente
                      aspectRatio: 0.8, // Relación de aspecto ajustada para que el personaje se vea más completo
                      child: Image.network( // O Image.asset si la imagen es local
                        widget.transformacion.image, // Usar la propiedad 'image' de tu modelo
                        fit: BoxFit.contain, // Mantiene la imagen completa dentro de su espacio
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
                              color: Colors.yellowAccent, // Color del indicador de carga
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              // Área de texto (nombre y Base KI) - Posicionada en la parte inferior
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                 // Agregado un Container para un fondo semi-transparente para el texto
                child: Container(
                  padding: const EdgeInsets.all(10), // Padding alrededor del texto
                  color: Colors.black54.withOpacity(0.7), // Fondo semi-transparente
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start, // Alinea el texto a la izquierda
                    mainAxisSize: MainAxisSize.min, // La columna ocupa el mínimo espacio vertical necesario
                    children: [
                      Text(
                        widget.transformacion.name, // Nombre de la transformación
                        style: const TextStyle(
                          color: Colors.white, // Color de texto
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1, // Limita el nombre a una línea
                        overflow: TextOverflow.ellipsis, // Añade puntos suspensivos si el nombre es muy largo
                      ),
                      const SizedBox(height: 4), // Espacio entre el nombre y el Base KI
                      Text(
                        // Usamos widget.transformacion.ki para obtener el Base KI
                        'Base KI: ${widget.transformacion.ki}', // Usar la propiedad 'ki' de tu modelo
                        style: const TextStyle(color: Colors.yellowAccent), // Color de texto
                        maxLines: 1, // Limita el Base KI a una línea
                        overflow: TextOverflow.ellipsis, // Añade puntos suspensivos si es muy largo
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
