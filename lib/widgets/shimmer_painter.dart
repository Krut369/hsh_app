// lib/modules/student/widgets/shimmer_painter.dart
import 'package:flutter/material.dart';

class ShimmerPainter extends CustomPainter {
  final double shimmer;
  ShimmerPainter(this.shimmer);

  @override
  void paint(Canvas canvas, Size size) {
    final gradient = LinearGradient(
      colors: [
        Colors.white.withOpacity(0.0),
        Colors.white.withOpacity(0.18),
        Colors.white.withOpacity(0.0),
      ],
      stops: const [0.25, 0.5, 0.75],
      begin: Alignment(-1.0 + 2 * shimmer, -1.0),
      end: Alignment(1.0 + 2 * shimmer, 1.0),
    );

    final paint = Paint()
      ..shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(covariant ShimmerPainter oldDelegate) => true;
}
