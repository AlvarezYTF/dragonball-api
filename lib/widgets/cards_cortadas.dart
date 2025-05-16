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
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final double cardWidth = (screenWidth * 0.7).clamp(180.0, 350.0);
    final double cardHeight = (screenHeight * 0.12).clamp(60.0, 110.0);
    final double cardPadding = (screenWidth * 0.07).clamp(12.0, 32.0);
    final double hoverOffset = (screenWidth * 0.06).clamp(8.0, 28.0);
    return Padding(
      padding: EdgeInsets.only(left: cardPadding),
      child: SizedBox(
        width: cardWidth,
        height: cardHeight,
        child: MouseRegion(
          onEnter: (_) => setState(() => _isHovering = true),
          onExit: (_) => setState(() => _isHovering = false),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 300),
                left: _isHovering ? -hoverOffset : 0,
                top: 0,
                curve: Curves.easeInOut,
                child: _buildTarjeta(cardWidth, cardHeight, screenWidth),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTarjeta(
    double cardWidth,
    double cardHeight,
    double screenWidth,
  ) {
    final double innerWidth = (cardWidth * 0.80).clamp(120.0, 320.0);
    final double innerHeight = (cardHeight * 0.5).clamp(30.0, 60.0);
    final double leftPadding = (screenWidth * 0.02).clamp(6.0, 18.0);
    final double fontSize = (screenWidth * 0.045).clamp(13.0, 18.0);
    final double strokeWidth = (screenWidth * 0.011).clamp(2.0, 4.0);
    return SizedBox(
      width: innerWidth,
      height: innerHeight,
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
          padding: EdgeInsets.only(left: leftPadding),
          child: Row(
            children: [
              SizedBox(width: screenWidth * 0.02),
              Expanded(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Stack(
                    children: [
                      Text(
                        widget.titulo,
                        style: TextStyle(
                          fontSize: fontSize,
                          fontWeight: FontWeight.w900,
                          fontStyle: FontStyle.italic,
                          height: 1.1,
                          foreground:
                              Paint()
                                ..style = PaintingStyle.stroke
                                ..strokeWidth = strokeWidth
                                ..color = Colors.black,
                        ),
                      ),
                      Text(
                        widget.titulo,
                        style: TextStyle(
                          fontSize: fontSize,
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
