import 'package:flutter/material.dart';

class StarfieldPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withAlpha((255 * 0.3).toInt())
      ..strokeWidth = 1.5;

    // Gambar beberapa titik bintang
    final stars = [
      Offset(size.width * 0.8, size.height * 0.15),
      Offset(size.width * 0.9, size.height * 0.6),
      Offset(size.width * 0.92, size.height * 0.87),
      Offset(size.width * 0.3, size.height * 0.9),
      Offset(size.width * 0.3, size.height * 0.10),
      Offset(size.width * 0.7, size.height * 0.8),
      Offset(size.width * 0.15, size.height * 0.5),
    ];

    for (var star in stars) {
      // Gambar titik
      canvas.drawCircle(star, 1.5, paint);

      // Gambar efek berkilau (optional)
      paint.strokeWidth = 0.8;
      canvas.drawLine(
        Offset(star.dx - 3, star.dy),
        Offset(star.dx + 3, star.dy),
        paint,
      );
      canvas.drawLine(
        Offset(star.dx, star.dy - 3),
        Offset(star.dx, star.dy + 3),
        paint,
      );
      paint.strokeWidth = 1.5;
    }

    // Tambahan efek circle blur (optional)
    final blurPaint = Paint()
      ..color = Colors.white.withAlpha((255 * 0.07).toInt())
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      Offset(size.width * 0.7, size.height * 0.1),
      30,
      blurPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.05, size.height * 0.1),
      30,
      blurPaint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.25, size.height * 0.8),
      20,
      blurPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
