import 'package:flutter/material.dart';
import '../models/planet.dart';
import '../services/planet_service.dart';
import 'character_detail_screen.dart';

class PlanetDetailScreen extends StatefulWidget {
  final Planeta planet;
  const PlanetDetailScreen({super.key, required this.planet});

  @override
  State<PlanetDetailScreen> createState() => _PlanetDetailScreenState();
}

class _PlanetDetailScreenState extends State<PlanetDetailScreen>
    with SingleTickerProviderStateMixin {
  late Future<Planeta> _planetDetailsFuture;
  final _planetService = PlanetService();
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _planetDetailsFuture = _planetService.getPlanetDetails(widget.planet.id);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.5, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1, curve: Curves.elasticOut),
      ),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          widget.planet.name,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                color: const Color(0xFF000000),
                blurRadius: 10,
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                const Color(0xB3000000), // Negro con 70% opacidad
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Opacity(
            opacity: _fadeAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: SweepGradient(
                    center: Alignment.center,
                    colors: [
                      const Color(0xE6232526), // 90% opacidad
                      const Color(0xB3414345), // 70% opacidad
                      const Color(0x80F7971E), // 50% opacidad
                      const Color(0x4DFFD200), // 30% opacidad
                      const Color(0xE6232526), // 90% opacidad
                    ],
                    stops: const [0.0, 0.3, 0.6, 0.8, 1.0],
                    transform: GradientRotation(_controller.value * 6.28),
                  ),
                ),
                child: FutureBuilder<Planeta>(
                  future: _planetDetailsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.orange,
                          ),
                        ),
                      );
                    }
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: const TextStyle(color: Colors.white),
                        ),
                      );
                    }
                    if (!snapshot.hasData) {
                      return const Center(
                        child: Text(
                          'No se encontraron datos del planeta',
                          style: TextStyle(color: Colors.white),
                        ),
                      );
                    }

                    final planet = snapshot.data!;
                    final characteresDelPlaneta = planet.characters;

                    return SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                          vertical: 80.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Planeta con efecto de brillo
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                AnimatedContainer(
                                  duration: const Duration(seconds: 2),
                                  curve: Curves.easeInOut,
                                  width: 220,
                                  height: 220,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0x66FFA500,
                                        ), // 40% opacidad
                                        blurRadius: 60,
                                        spreadRadius: 20,
                                      ),
                                      BoxShadow(
                                        color: const Color(
                                          0x33FFFF00,
                                        ), // 20% opacidad
                                        blurRadius: 90,
                                        spreadRadius: 30,
                                      ),
                                    ],
                                  ),
                                ),
                                Hero(
                                  tag: 'planet-${planet.id}',
                                  child: ClipOval(
                                    child: Image.network(
                                      planet.image,
                                      height: 200,
                                      width: 200,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (
                                        context,
                                        child,
                                        loadingProgress,
                                      ) {
                                        if (loadingProgress == null) {
                                          return child;
                                        }
                                        return Container(
                                          width: 200,
                                          height: 200,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            shape: BoxShape.circle,
                                          ),
                                          child: Center(
                                            child: CircularProgressIndicator(
                                              value:
                                                  loadingProgress
                                                              .expectedTotalBytes !=
                                                          null
                                                      ? loadingProgress
                                                              .cumulativeBytesLoaded /
                                                          loadingProgress
                                                              .expectedTotalBytes!
                                                      : null,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 40),

                            // Sección de descripción
                            SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.5),
                                end: Offset.zero,
                              ).animate(
                                CurvedAnimation(
                                  parent: _controller,
                                  curve: const Interval(
                                    0.4,
                                    0.8,
                                    curve: Curves.easeOutQuad,
                                  ),
                                ),
                              ),
                              child: FadeTransition(
                                opacity: _fadeAnimation,
                                child: Container(
                                  padding: const EdgeInsets.all(20),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                      0x66000000,
                                    ), // 40% opacidad
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: const Color(
                                        0x80FFA500,
                                      ), // 50% opacidad
                                      width: 1,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(
                                          0x80000000,
                                        ), // 50% opacidad
                                        blurRadius: 20,
                                        offset: const Offset(0, 10),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Descripción',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge?.copyWith(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26,
                                          shadows: [
                                            Shadow(
                                              color: const Color(
                                                0xB3000000,
                                              ), // 70% opacidad
                                              blurRadius: 5,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 12),
                                      Text(
                                        planet.description,
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: const Color(
                                            0xE6FFFFFF,
                                          ), // 90% opacidad
                                          fontWeight: FontWeight.w400,
                                          height: 1.5,
                                          shadows: [
                                            Shadow(
                                              color: const Color(
                                                0xB3000000,
                                              ), // 70% opacidad
                                              blurRadius: 5,
                                              offset: const Offset(1, 1),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 40),

                            // Sección de personajes
                            if (characteresDelPlaneta.isNotEmpty) ...[
                              SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0, 0.5),
                                  end: Offset.zero,
                                ).animate(
                                  CurvedAnimation(
                                    parent: _controller,
                                    curve: const Interval(
                                      0.5,
                                      0.9,
                                      curve: Curves.easeOutQuad,
                                    ),
                                  ),
                                ),
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Personajes Originarios',
                                        style: Theme.of(
                                          context,
                                        ).textTheme.titleLarge?.copyWith(
                                          color: Colors.orangeAccent,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 26,
                                          shadows: [
                                            Shadow(
                                              color: const Color(
                                                0xB3000000,
                                              ), // 70% opacidad
                                              blurRadius: 5,
                                              offset: const Offset(2, 2),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            const SliverGridDelegateWithFixedCrossAxisCount(
                                              crossAxisCount: 3,
                                              crossAxisSpacing: 20,
                                              mainAxisSpacing: 20,
                                              childAspectRatio: 0.55,
                                            ),
                                        itemCount: characteresDelPlaneta.length,
                                        itemBuilder: (context, index) {
                                          return _AnimatedCharacterCard(
                                            character:
                                                characteresDelPlaneta[index],
                                            delay: index * 0.1,
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ] else
                              const Text(
                                'No hay personajes originarios de este planeta.',
                                style: TextStyle(color: Colors.white),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedCharacterCard extends StatefulWidget {
  final dynamic character;
  final double delay;

  const _AnimatedCharacterCard({required this.character, this.delay = 0});

  @override
  State<_AnimatedCharacterCard> createState() => _AnimatedCharacterCardState();
}

class _AnimatedCharacterCardState extends State<_AnimatedCharacterCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<Offset> _offsetAnimation;

  bool _isHovering = false;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0, 0.7, curve: Curves.elasticOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.3, 1, curve: Curves.easeIn),
      ),
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.2, 1, curve: Curves.easeOutQuad),
      ),
    );

    Future.delayed(Duration(milliseconds: (300 * widget.delay).round()), () {
      if (mounted) {
        _controller.forward();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              return FadeTransition(
                opacity: animation,
                child: CharacterDetailScreen(character: widget.character),
              );
            },
          ),
        );
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return SlideTransition(
              position: _offsetAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _opacityAnimation,
                  child: AnimatedScale(
                    scale: _isHovering ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: EdgeInsets.all(_isHovering ? 0 : 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xB3000000), // 70% opacidad
                            const Color(0xE6212121), // 90% opacidad
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color:
                              _isHovering
                                  ? const Color(0xCCFFA500) // 80% opacidad
                                  : const Color(0x66FFA500), // 40% opacidad
                          width: _isHovering ? 2.5 : 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color:
                                _isHovering
                                    ? const Color(0x66FFA500) // 40% opacidad
                                    : const Color(0x33FFA500), // 20% opacidad
                            blurRadius: _isHovering ? 20 : 10,
                            spreadRadius: _isHovering ? 2 : 1,
                            offset: Offset(0, _isHovering ? 8 : 4),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const SizedBox(height: 12),
                          Hero(
                            tag: 'character-${widget.character.id}',
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(
                                      0xAA6A82FB,
                                    ), // azul claro brillante
                                    blurRadius: 30,
                                    spreadRadius: 8,
                                  ),
                                  BoxShadow(
                                    color: const Color(
                                      0x88FC5C7D,
                                    ), // rosa galaxia
                                    blurRadius: 50,
                                    spreadRadius: 16,
                                  ),
                                ],
                                border: Border.all(
                                  color: const Color(0xFF6A82FB),
                                  width: 2,
                                ),
                              ),
                              child: ClipOval(
                                child: Image.network(
                                  widget.character.image,
                                  width: 65,
                                  height: 75,
                                  fit: BoxFit.contain,
                                  loadingBuilder: (
                                    context,
                                    child,
                                    loadingProgress,
                                  ) {
                                    if (loadingProgress == null) return child;
                                    return Container(
                                      width: 80,
                                      height: 100,
                                      color: const Color(0xFF232526),
                                      child: Center(
                                        child: CircularProgressIndicator(
                                          value:
                                              loadingProgress
                                                          .expectedTotalBytes !=
                                                      null
                                                  ? loadingProgress
                                                          .cumulativeBytesLoaded /
                                                      loadingProgress
                                                          .expectedTotalBytes!
                                                  : null,
                                          strokeWidth: 2,
                                          color: const Color(0xFF6A82FB),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8.0,
                            ),
                            child: Text(
                              widget.character.name,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: const Color(
                                      0xB3000000,
                                    ), // 70% opacidad
                                    blurRadius: 5,
                                    offset: const Offset(1, 1),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
