import 'package:flutter/material.dart';

class NovedadesCard extends StatefulWidget {
  final String titulo;
  const NovedadesCard({super.key, required this.titulo});

  @override
  State<NovedadesCard> createState() => _NovedadesCardState();
}

class _NovedadesCardState extends State<NovedadesCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: SizedBox(
        width: 300,
        height: 100,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: _isHovering ? -30 : 0,
                top: 0,
                curve: Curves.easeInOut,
                child: _buildTarjeta(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTarjeta() {
    return SizedBox(
      width: 250,
      height: 50,
      child: ClipPath(
        clipper: EsquinaCortadaClipper(),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.black, Color(0xFFFFC107)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          padding: const EdgeInsets.only(left: 35),
          child: Row(
            children: [
              const SizedBox(width: 12),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Text(
                        widget.titulo,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          height: 1.1,
                          foreground:
                              Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 4
                                ..color = Colors.black,
                        ),
                      ),
                      Text(
                        widget.titulo,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          height: 1.1,
                          color: Colors.white,
                        ),
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

class EsquinaCortadaClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double slope = 25;

    return Path()
      ..moveTo(slope, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width - slope, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}