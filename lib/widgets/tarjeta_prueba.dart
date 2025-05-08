import 'package:flutter/material.dart';

class NovedadesCard extends StatefulWidget {
  const NovedadesCard({super.key});

  @override
  State<NovedadesCard> createState() => _NovedadesCardState();
}

class _NovedadesCardState extends State<NovedadesCard> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 200),
        scale: _isHovering ? 1.05 : 1.0,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 220,
          height: 70,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(_isHovering ? 0.6 : 0.3),
                blurRadius: _isHovering ? 12 : 6,
                offset: const Offset(6, 6),
              )
            ],
          ),
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
              padding: const EdgeInsets.only(left: 16),
              child: Row(
                children: [
                  const Icon(Icons.close, color: Colors.white, size: 30),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Stack(
                        children: [
                          Text(
                            'Transformaciones',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.italic,
                              height: 1.1,
                              foreground: Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = 4
                                ..color = Colors.black,
                            ),
                          ),
                          const Text(
                            'Transformaciones',
                            style: TextStyle(
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
        ),
      ),
    );
  }
}

class EsquinaCortadaClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    const double cutSize = 20.0;
    return Path()
      ..moveTo(cutSize, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..lineTo(0, cutSize)
      ..close();
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}