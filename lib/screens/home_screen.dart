import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/dragonballs_loader.dart';
import '../widgets/floating_dragonball.dart';
// import '../widgets/slicen_dragonball_home.dart';
// import '../widgets/etiqueta_button.dart';
import '../screens/transformations.dart';
import '../widgets/cards_cortadas.dart';
import '../widgets/lateral_animated.dart';
import '../widgets/hitflash.dart';
import 'dart:async';
import '../widgets/card_home.dart';

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

  @override
  void initState() {
    super.initState();
    _loadInitialData();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animationFloat = Tween<double>(
      begin: -10,
      end: 10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _startFlashes();
  }

  Future<void> _loadInitialData() async {
    await Future.delayed(const Duration(seconds: 4)); // Simula carga inicial
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _startFlashes() {
    Timer.periodic(const Duration(milliseconds: 100), (timer) {
      final screenWidth = MediaQuery.of(context).size.width;
      final screenHeight = MediaQuery.of(context).size.height;

      final randomX = _random.nextDouble() * (screenWidth - 100);
      final randomY = _random.nextDouble() * (screenHeight - 100);

      final imageOptions = [
        'assets/effects/flash1.png',
        'assets/effects/flash2.png',
        'assets/effects/flash3.png',
      ];
      final selectedImage = imageOptions[_random.nextInt(imageOptions.length)];

      final flash = HitFlash(
        position: Offset(randomX, randomY),
        imagePath: selectedImage,
        size: 100,
      );

      setState(() => _flashes.add(flash));

      // Quita el flash después de 500 ms
      Future.delayed(const Duration(milliseconds: 900), () {
        if (_flashes.isNotEmpty && mounted) {
          setState(() => _flashes.remove(flash));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonWidth = screenWidth - 40;

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body:
          _isLoading
              ? const Center(
                child: SizedBox(
                  height: 150,
                  child: DragonBallsLoader(duration: Duration(seconds: 7)),
                ),
              )
              : Stack(
                children: [
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Color(0xFF0A0A23)],
                      ),
                    ),
                  ),

                  Positioned(
                    top: 40,
                    right: -105,
                    child: MouseRegion(
                      cursor:
                          SystemMouseCursors
                              .click, // 👈 activa el cursor de manito
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => const TransformacionesScreen(),
                            ),
                          );
                        },
                        child: const NovedadesCard(titulo: "Transformaciones"),
                      ),
                    ),
                  ),

                  const Positioned(
                    top: 100,
                    right: -105,
                    child: NovedadesCard(titulo: "Personajes"),
                  ),
                  const Positioned(
                    top: 160,
                    right: -105,
                    child: NovedadesCard(titulo: "Planetas"),
                  ),

                  /// Esferas del dragón (7 distintas)
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_1.png',
                    size: 40,
                    left: 400,
                    top: 100,
                    animation: _animationFloat,
                  ),
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_3.png',
                    size: 45,
                    left: 410,
                    top: 560,
                    animation: _animationFloat,
                  ),
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_4.png',
                    size: 65,
                    left: 800,
                    top: 120,
                    animation: _animationFloat,
                  ),
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_5.png',
                    size: 55,
                    left: 490,
                    top: 340,
                    animation: _animationFloat,
                  ),

                  Positioned(
                    top: MediaQuery.of(context).size.height / 2 - 310,
                    left: MediaQuery.of(context).size.width / 2 - 310,
                    child: Image.asset(
                      'assets/images/goku_jiren.png',
                      width: 700,
                      height: 700,
                    ),
                  ),
                  Positioned(
                    top: MediaQuery.of(context).size.height / 2 - -30,
                    left: MediaQuery.of(context).size.width / 2 - 150,
                    child: Image.asset(
                      'assets/logo_dragonballapi.webp',
                      width: 300,
                      height: 300,
                    ),
                  ),
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_2.png',
                    size: 50,
                    left: 520,
                    top: 180,
                    animation: _animationFloat,
                  ),
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_7.png',
                    size: 60,
                    left: 770,
                    top: 600,
                    animation: _animationFloat,
                  ),
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_6.png',
                    size: 50,
                    left: 680,
                    top: 420,
                    animation: _animationFloat,
                  ),
                  Positioned(
                    left: 0,
                    top: -30,
                    child: Column(
                      children: [
                        LateralAnimatedImage(
                          imagePaths: [
                            'assets/images/laterales/slider2_broly.jpg',
                            'assets/images/laterales/slider2_goku_black.jpg',
                            'assets/images/laterales/slider2_goku4.jpg',
                          ],
                        ),
                        const SizedBox(height: 5),
                        LateralAnimatedImage(
                          imagePaths: [
                            'assets/images/laterales/slider2_vegeta4.jpg',
                            'assets/images/laterales/slider2_ultra.jpg',
                            'assets/images/laterales/slider2_vegito.jpg',
                          ],
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    top: 500, // Posición desde arriba
                    left: 20, // Posición desde la izquierda
                    width: buttonWidth,
                    child: NavButton(
                      title: 'Vinculación con Bandai Namco ID',
                      onTap: () {},
                    ),
                  ),
                  Positioned(
                    top: 430, // Posición desde arriba
                    left: 20, // Posición desde la izquierda
                    width: buttonWidth,
                    child: NavButton(
                      title: 'Vinculación con Bandai Namco ID',
                      onTap: () {},
                    ),
                  ),
                  ..._flashes,
                ],
              ),
    );
  }
}
