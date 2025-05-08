import 'package:flutter/material.dart';
import '../widgets/dragonballs_loader.dart';
import '../widgets/floating_dragonball.dart';
import '../widgets/slicen_dragonball_home.dart';
import '../widgets/tarjeta_prueba.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  bool _isLoading = true;
  late AnimationController _controller;
  late Animation<double> _animationFloat;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
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
                  const FondoSlider(), // Fondo con slider
                  Container(
                    color: Colors.black.withOpacity(0.5), // Oscurece el fondo
                  ),

                  Positioned(
                    top: 20,
                    right: 16,
                    child: NovedadesCard(),
                  ), // Fondo con slider
                  /// Logo centrado
                  Center(
                    child: Image.asset(
                      'assets/logo_dragonballapi.webp',
                      width: 300,
                    ),
                  ),

                  /// Goku animado
                  AnimatedBuilder(
                    animation: _animationFloat,
                    builder:
                        (_, __) => Positioned(
                          left: MediaQuery.of(context).size.width / 2 - 300,
                          top: 200,
                          child: Image.asset(
                            'assets/images/gogeta.webp',
                            width: 170,
                          ),
                        ),
                  ),

                  /// Jiren animado
                  AnimatedBuilder(
                    animation: _animationFloat,
                    builder:
                        (_, __) => Positioned(
                          right: MediaQuery.of(context).size.width / 2 - 250,
                          top: 210,
                          child: Image.asset(
                            'assets/images/jiren.webp',
                            width: 137,
                          ),
                        ),
                  ),

                  // AnimatedBuilder(
                  //   animation: _animationFloat,
                  //   builder: (_, __) => Positioned(
                  //     left: MediaQuery.of(context).size.width / 2 - 500,
                  //     top: 210,
                  //     child: Image.asset('assets/images/Shen_Long.webp', width: 137),
                  //   ),
                  // ),

                  /// Esferas del dragón (7 distintas)
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_1.png',
                    size: 40,
                    left: 30,
                    top: 100,
                    animation: _animationFloat,
                  ),
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_2.png',
                    size: 50,
                    left: 120,
                    top: 180,
                    animation: _animationFloat,
                  ),
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_3.png',
                    size: 45,
                    left: 210,
                    top: 260,
                    animation: _animationFloat,
                  ),
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_4.png',
                    size: 65,
                    left: 300,
                    top: 120,
                    animation: _animationFloat,
                  ),
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_5.png',
                    size: 55,
                    left: 90,
                    top: 340,
                    animation: _animationFloat,
                  ),
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_6.png',
                    size: 50,
                    left: 180,
                    top: 420,
                    animation: _animationFloat,
                  ),
                  FloatingDragonBall(
                    imagePath: 'assets/esferas_dragon/esfera_7.png',
                    size: 60,
                    left: 270,
                    top: 600,
                    animation: _animationFloat,
                  ),
                ],
              ),
    );
  }
}
