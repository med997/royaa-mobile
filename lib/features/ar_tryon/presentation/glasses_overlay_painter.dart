import 'package:flutter/material.dart';

class GlassesOverlayPainter extends CustomPainter {
  const GlassesOverlayPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;

    final cy = size.height * 0.42;
    final lensW = size.width * 0.24;
    final lensH = size.width * 0.16;
    final gap = size.width * 0.08;
    final cx = size.width / 2;

    final left = Rect.fromCenter(center: Offset(cx - lensW / 2 - gap / 2, cy), width: lensW, height: lensH);
    final right = Rect.fromCenter(center: Offset(cx + lensW / 2 + gap / 2, cy), width: lensW, height: lensH);

    canvas.drawRRect(RRect.fromRectAndRadius(left, const Radius.circular(18)), paint);
    canvas.drawRRect(RRect.fromRectAndRadius(right, const Radius.circular(18)), paint);
    canvas.drawLine(Offset(left.right, cy), Offset(right.left, cy), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
