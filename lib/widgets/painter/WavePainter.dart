import 'package:flutter/material.dart';

class WavePainter extends CustomPainter {
  final Color waveColor;

  WavePainter({required this.waveColor});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = waveColor
      ..style = PaintingStyle.fill
      ..isAntiAlias = false;

    final double offsetY = 10;
    final double baseline = size.height - offsetY;
    final double amplitude = 10;
    final double extra = 1.0;
    final double bottom = size.height + extra;

    final path = Path()
      ..moveTo(0, bottom)
      ..lineTo(0, baseline)
      ..quadraticBezierTo(
        size.width * 0.125, baseline + amplitude,
        size.width * 0.25, baseline,
      )
      ..quadraticBezierTo(
        size.width * 0.375, baseline - amplitude,
        size.width * 0.5, baseline,
      )
      ..quadraticBezierTo(
        size.width * 0.625, baseline + amplitude,
        size.width * 0.75, baseline,
      )
      ..quadraticBezierTo(
        size.width * 0.875, baseline - amplitude,
        size.width, baseline,
      )
      ..lineTo(size.width, bottom)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
