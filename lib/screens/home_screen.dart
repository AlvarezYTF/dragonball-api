import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/dragonballs_loader.dart';
import '../widgets/floating_dragonball.dart';
import '../screens/transformations.dart';
import '../widgets/cards_cortadas.dart'; // Asegúrate de que este widget exista
import '../widgets/hitflash.dart'; // Asegúrate de que este widget exista
import 'dart:async';
import 'characters_screen.dart'; // Asegúrate de que esta pantalla exista
import 'planets_screen.dart'; // Asegúrate de que esta pantalla exista

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _controller;
  late Animation<double> _animationFloat;
  final List<Widget> _flashes = [];
  final Random _random = Random();
  Timer? _flashesTimer; // Rastrea el temporizador

  @override
  void initState() {
    super.initState();
    _loadInitialData();

    // Controlador para la animación flotante de las esferas del dragón
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animationFloat = Tween<double>(
      begin: -10, // Desplazamiento inicial en píxeles
      end: 10, // Desplazamiento final en píxeles
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startFlashes(); // Inicia la animación de flashes
  }

  // Simula la carga de datos iniciales
  Future<void> _loadInitialData() async {
    await Future.delayed(const Duration(seconds: 2)); // Reducido para pruebas más rápidas
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Libera el controlador de animación
    _flashesTimer?.cancel(); // Cancela el temporizador de flashes
    super.dispose();
  }

  // Inicia la generación periódica de flashes
  void _startFlashes() {
    _flashesTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) { // Frecuencia de aparición de flashes
      if (!mounted || _isLoading) { // Detiene si el widget no está montado o si aún está cargando
        timer.cancel();
        _flashesTimer = null;
        return;
      }
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      // Ajusta el tamaño del flash según el tamaño de la pantalla
      final flashSize = isMobile(screenWidth) ? 50.0 : 100.0;

      // Genera una posición aleatoria dentro de los límites de la pantalla, considerando el tamaño del flash
      final randomX = _random.nextDouble() * (screenWidth - flashSize);
      final randomY = _random.nextDouble() * (screenHeight - flashSize);

      // Rutas de las imágenes para los flashes (asegúrate de que sean correctas)
      const imageOptions = ['assets/effects/flash1.png'];
      final selectedImage = imageOptions[_random.nextInt(imageOptions.length)];

      final flash = HitFlash(
        position: Offset(randomX, randomY),
        imagePath: selectedImage,
        size: flashSize,
      );

      // Limita el número de flashes simultáneos para optimizar el rendimiento
      if (_flashes.length < (isMobile(screenWidth) ? 10 : 20)) {
        setState(() => _flashes.add(flash));
      }

      // Elimina el flash después de una duración
      Future.delayed(const Duration(milliseconds: 900), () {
        if (mounted) { // Verifica si el widget aún está activo antes de actualizar el estado
          setState(() => _flashes.remove(flash));
        }
      });
    });
  }

  // Determina si la pantalla es móvil basado en el ancho
  bool isMobile(double screenWidth) => screenWidth < 600;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final mobile = isMobile(screenWidth);

    // --- Cálculos para Posicionar y Escalar Elementos ---

    // Ancho de la columna principal que contendrá el logo, imagen y menú
    final double mainContentWidth = screenWidth * (mobile ? 0.9 : 0.5);

    // Altura de la imagen de Goku y Jiren, relativa al ancho del contenido principal
    final double gokuJirenHeight = mainContentWidth * (mobile ? 0.9 : 0.7);

    // Altura del logo, relativa al ancho del contenido principal
    final double logoHeight = mainContentWidth * (mobile ? 0.25 : 0.2);

    // Ancho de las tarjetas del menú, relativo al ancho del contenido principal
    final double menuCardWidth = mainContentWidth * 0.95;

    // Tamaño de las esferas del dragón, escala con el ancho de la pantalla
    final double ballSize = screenWidth * (mobile ? 0.08 : 0.05);

    // Posiciones de las Esferas del Dragón (se ajustan según la pantalla)
    // Estas coordenadas x, y son porcentajes de ancho y alto de la pantalla.
     final List<Map<String, double>> dragonBallsPositions = [
      {"x": 0.1, "y": 0.1}, {"x": 0.9, "y": 0.15}, {"x": 0.05, "y": 0.5},
      {"x": 0.85, "y": 0.55}, {"x": 0.15, "y": 0.8}, {"x": 0.75, "y": 0.85},
      {"x": 0.5, "y": 0.95},
    ];


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: _isLoading
          ? const Center(
              child: SizedBox(
                height: 150,
                child: DragonBallsLoader(duration: Duration(seconds: 4)),
              ),
            )
          : Stack(
              children: [
                // 1. Plataforma del Torneo (Fondo - Área Roja)
                Positioned.fill(
                  child: Image.asset(
                    'assets/images/torneo.jpg', // Asegúrate de que la ruta sea correcta
                    fit: BoxFit.cover, // Prioriza cubrir el espacio, puede recortar bordes
                  ),
                ),

                // 2. Esferas del Dragón (Detrás del contenido principal)
                 ...List.generate(dragonBallsPositions.length, (index) {
                  final position = dragonBallsPositions[index];
                   return Positioned(
                    // Centra la esfera en el punto porcentual calculado
                    left: screenWidth * position["x"]! - (ballSize / 2),
                    top: screenHeight * position["y"]! - (ballSize / 2),
                    child: FloatingDragonBall(
                      // Asegúrate de que las rutas de las imágenes sean correctas
                      imagePath: 'assets/esferas_dragon/esfera_${index + 1}.png',
                      size: ballSize, // Tamaño relativo al ancho de la pantalla
                      animation: _animationFloat,
                    ),
                  );
                }),

                // Contenido Principal (Logo, Goku/Jiren, Menú) - Centrado y con Scroll
                Center(
                  child: SingleChildScrollView( // Permite hacer scroll si el contenido excede la altura
                    child: Container(
                      width: mainContentWidth, // Limita el ancho del contenido principal
                       padding: EdgeInsets.only(bottom: screenHeight * 0.05), // Padding inferior para subir ligeramente el contenido
                      child: Column(
                        mainAxisSize: MainAxisSize.min, // La columna ocupa el mínimo espacio vertical necesario
                        mainAxisAlignment: MainAxisAlignment.center, // Centra verticalmente el contenido dentro de la columna
                        crossAxisAlignment: CrossAxisAlignment.center, // Centra horizontalmente el contenido dentro de la columna
                        children: [
                          // Logo (Área Azul)
                          SizedBox(
                            height: logoHeight, // Altura responsiva
                            child: Image.asset(
                              'assets/logo_dragonballapi.webp', // Asegúrate de que la ruta sea correcta
                              fit: BoxFit.contain, // Contiene la imagen manteniendo su proporción
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.02), // Espacio entre logo y Goku/Jiren

                          // Imagen de Goku y Jiren (Área Verde)
                          SizedBox(
                             height: gokuJirenHeight, // Altura responsiva
                             child: Image.asset(
                               'assets/images/goku_jiren.png', // Asegúrate de que la ruta sea correcta
                               fit: BoxFit.contain, // Contiene la imagen manteniendo su proporción
                             ),
                           ),
                           SizedBox(height: screenHeight * 0.04), // Espacio entre Goku/Jiren y el menú

                          // Menú (Área Amarilla) - Tarjetas
                           Container( // Contenedor para controlar el ancho del menú
                             width: menuCardWidth, // Ancho responsivo
                             padding: EdgeInsets.symmetric(horizontal: menuCardWidth * 0.05), // Padding interno para las tarjetas
                             child: Column(
                               mainAxisSize: MainAxisSize.min,
                               crossAxisAlignment: CrossAxisAlignment.stretch, // Estira las tarjetas horizontalmente
                               children: [
                                 // Tarjeta Personajes
                                 MouseRegion(
                                   cursor: SystemMouseCursors.click,
                                   child: GestureDetector(
                                     onTap: () {
                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                           builder: (context) => const CharactersScreen(),
                                         ),
                                       );
                                     },
                                     child: const NovedadesCard(titulo: "Personajes"), // Asegúrate de que este widget funcione correctamente
                                   ),
                                 ),
                                 SizedBox(height: screenHeight * 0.015), // Espacio entre tarjetas

                                 // Tarjeta Transformaciones
                                 MouseRegion(
                                   cursor: SystemMouseCursors.click,
                                   child: GestureDetector(
                                     onTap: () {
                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                           builder: (context) => const TransformacionesScreen(),
                                         ),
                                       );
                                     },
                                     child: const NovedadesCard(titulo: "Transformaciones"), // Asegúrate de que este widget funcione correctamente
                                   ),
                                 ),
                                 SizedBox(height: screenHeight * 0.015), // Espacio entre tarjetas

                                 // Tarjeta Planetas
                                 MouseRegion(
                                   cursor: SystemMouseCursors.click,
                                   child: GestureDetector(
                                     onTap: () {
                                       Navigator.push(
                                         context,
                                         MaterialPageRoute(
                                           builder: (context) => const PlanetsScreen(),
                                         ),
                                       );
                                     },
                                     child: const NovedadesCard(titulo: "Planetas"), // Asegúrate de que este widget funcione correctamente
                                   ),
                                 ),
                               ],
                             ),
                           ),
                        ],
                      ),
                    ),
                  ),
                ),

                // Flashes (en la capa superior)
                ..._flashes,
              ],
            ),
    );
  }
}