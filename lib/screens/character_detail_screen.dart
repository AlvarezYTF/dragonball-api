import 'package:flutter/material.dart';
import '../models/character.dart'; // Asegúrate de que Personaje tiene una propiedad 'id'
import '../models/transformation.dart';
import '../services/transformacion_service.dart';

class CharacterDetailScreen extends StatefulWidget {
  final Personaje personaje;
  final VoidCallback onClose;

  const CharacterDetailScreen({
    super.key,
    required this.personaje,
    required this.onClose,
  });

  @override
  State<CharacterDetailScreen> createState() => _CharacterDetailScreenState();
}

class _CharacterDetailScreenState extends State<CharacterDetailScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  List<Transformacion> _transformations =
      []; // Usamos Transformacion como en el modelo
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack,
    );
    _controller.forward();

    // Llama a la función que carga las transformaciones del personaje específico
    _loadTransformations();
  }

  void _loadTransformations() async {
    setState(() {
      _isLoading = true; // Mostrar indicador de carga antes de la petición
    });
    try {
      // !!! Llamamos al NUEVO método pasando el ID del personaje !!!
      final data = await TransformacionService().fetchTransformaciones();
      setState(() {
        _transformations = data;
        _isLoading = false;
      });
    } catch (e) {
      print(
        'Error loading transformations for character ${widget.personaje.id}: $e',
      ); // Imprimir error
      setState(() {
        _transformations =
            []; // En caso de error, mostrar lista vacía o un mensaje
        _isLoading = false;
      });
      // Opcional: Mostrar un SnackBar o un mensaje de error en la UI
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(204), // 0.8 opacidad
      body: SafeArea(
        child: Center(
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 320,
              constraints: const BoxConstraints(maxHeight: 500),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(242), // 0.95 opacidad
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(128),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // La imagen principal del personaje no es el problema
                    Image.network(widget.personaje.image, height: 200),
                    const SizedBox(height: 10),
                    Text(
                      widget.personaje.name,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Detalles del personaje (Ki, Grupo, Descripción)
                    Text(
                      'Ki Base: ${widget.personaje.ki}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Ki Máximo: ${widget.personaje.maxKi}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Grupo: ${widget.personaje.affiliation}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      widget.personaje.description,
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 14),
                    ),
                    const SizedBox(height: 20),
                    // Sección de transformaciones
                    const Text(
                      'Transformaciones:',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Mostrar estado de carga, mensaje sin transformaciones o la lista
                    if (_isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (_transformations.isEmpty)
                      const Text(
                        // Este mensaje ahora será más preciso si la API devuelve una lista vacía para el personaje
                        'Este personaje no tiene transformaciones registradas',
                        style: TextStyle(fontSize: 14),
                      )
                    else
                      // Mapear la lista de transformaciones obtenidas del personaje
                      Column(
                        children:
                            _transformations.map((t) {
                              return Container(
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Color.fromARGB(
                                    51,
                                    255,
                                    152,
                                    0,
                                  ), // Un poco de transparencia
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(color: Colors.orange),
                                ),
                                child: ListTile(
                                  leading: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    // !!! Manejamos la posible nulidad de la imagen !!!
                                    child:
                                        (t.image.isNotEmpty) // <<< Simplificado a solo verificar si NO está vacío
                                            ? Image.network(
                                              t.image, // Ya no necesitas el '!' si el tipo es String no nulo
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (
                                                    context,
                                                    error,
                                                    stackTrace,
                                                  ) => const Icon(
                                                    Icons.broken_image,
                                                    size: 50,
                                                  ),
                                            )
                                            : const Icon(
                                              Icons.image_not_supported,
                                              size: 50,
                                              color: Colors.grey,
                                            ),
                                  ),
                                  title: Text(
                                    t.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color:
                                          Colors
                                              .black87, // Color de texto para contraste
                                    ),
                                  ),
                                  subtitle: Text(
                                    'Ki: ${t.ki}', // Mostramos el Ki de la transformación
                                    style: TextStyle(color: Colors.black54),
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    const SizedBox(height: 20),
                    // Botón de cerrar
                    ElevatedButton.icon(
                      onPressed: widget.onClose,
                      icon: const Icon(Icons.close),
                      label: const Text('Cerrar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
