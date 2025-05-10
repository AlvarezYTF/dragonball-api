import 'package:flutter/material.dart';
import 'dart:math';
import '../widgets/dragonballs_loader.dart';
import '../widgets/floating_dragonball.dart';
import '../screens/transformations.dart';
import '../widgets/cards_cortadas.dart';
import '../widgets/hitflash.dart';
import 'dart:async';

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
    final screenHeight = MediaQuery.of(context).size.height;
    final double imgWidth = (screenWidth * 0.95).clamp(220.0, 600.0);
    final double leftPos = (screenWidth - imgWidth) / 2;
    final double logoWidth = (screenWidth * 0.55).clamp(140.0, 350.0);
    final double logoLeftPos = (screenWidth - logoWidth) / 2;
    final double logoTop =
        screenHeight * 0.10 + (imgWidth / 2) - (logoWidth / 2) + 50;
    final isMobile = screenWidth < 600;
    final double topPos = screenHeight * 0.10;

    final List<Map<String, double>> dragonBalls = [
      {"x": 0.15, "y": 0.10, "size": 0.13}, // esfera 1
      {"x": 0.05, "y": 0.43, "size": 0.13}, // esfera 2
      {"x": 0.75, "y": 0.10, "size": 0.13}, // esfera 3
      {"x": 0.20, "y": 0.70, "size": 0.13}, // esfera 4
      {"x": 0.65, "y": 0.65, "size": 0.13}, // esfera 5
      {"x": 0.58, "y": 0.35, "size": 0.11}, // esfera 6
      {"x": 0.50, "y": 0.80, "size": 0.13}, // esfera 7
    ];

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

                  if (isMobile)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          MouseRegion(
                            cursor: SystemMouseCursors.click,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            const TransformacionesScreen(),
                                  ),
                                );
                              },
                              child: const NovedadesCard(
                                titulo: "Transformaciones",
                              ),
                            ),
                          ),
                          const NovedadesCard(titulo: "Personajes"),
                          const NovedadesCard(titulo: "Planetas"),
                        ],
                      ),
                    )
                  else ...[
                    Positioned(
                      top: screenHeight * 0.04,
                      right: -screenWidth * 0.1,
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
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
                          child: const NovedadesCard(
                            titulo: "Transformaciones",
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: screenHeight * 0.12,
                      right: -screenWidth * 0.1,
                      child: const NovedadesCard(titulo: "Personajes"),
                    ),
                    Positioned(
                      top: screenHeight * 0.20,
                      right: -screenWidth * 0.1,
                      child: const NovedadesCard(titulo: "Planetas"),
                    ),
                  ],

                  ...[0, 2, 4].map((i) {
                    final ball = dragonBalls[i];
                    return Positioned(
                      left: leftPos + imgWidth * ball["x"]!,
                      top: topPos + imgWidth * ball["y"]!,
                      child: FloatingDragonBall(
                        imagePath: 'assets/esferas_dragon/esfera_${i + 1}.png',
                        size: imgWidth * ball["size"]!,
                        animation: _animationFloat,
                      ),
                    );
                  }),
                  Positioned(
                    top: screenHeight * 0.10,
                    left: leftPos,
                    child: Image.asset(
                      'assets/images/goku_jiren.png',
                      width: imgWidth,
                      height: imgWidth,
                    ),
                  ),
                  Positioned(
                    top: logoTop,
                    left: logoLeftPos,
                    child: Image.asset(
                      'assets/logo_dragonballapi.webp',
                      width: logoWidth,
                      height: logoWidth,
                    ),
                  ),
                  ...[1, 3, 5, 6].map((i) {
                    final ball = dragonBalls[i];
                    return Positioned(
                      left: leftPos + imgWidth * ball["x"]!,
                      top: topPos + imgWidth * ball["y"]!,
                      child: FloatingDragonBall(
                        imagePath: 'assets/esferas_dragon/esfera_${i + 1}.png',
                        size: imgWidth * ball["size"]!,
                        animation: _animationFloat,
                      ),
                    );
                  }),
                  ..._flashes,
                ],
              ),
    );
  }
}
