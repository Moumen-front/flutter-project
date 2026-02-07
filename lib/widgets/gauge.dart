import 'package:flutter/material.dart';

class HorizontalEllipseGauge extends StatelessWidget {
  final double width;
  final double height;
  final double progress; // 0.0 to 1.0
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  const HorizontalEllipseGauge({
    Key? key,
    required this.width,
    required this.height,
    required this.progress,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = Colors.green,
    this.strokeWidth = 10.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        painter: _HorizontalEllipseGaugePainter(
          progress: progress.clamp(0.0, 1.0),
          backgroundColor: backgroundColor,
          progressColor: progressColor,
          strokeWidth: strokeWidth,
        ),
      ),
    );
  }
}

class _HorizontalEllipseGaugePainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  _HorizontalEllipseGaugePainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint bgPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    final Paint progressPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.square;

    // Draw the background ellipse
    Rect rect = Rect.fromLTWH(0, size.height/4, size.width, size.height);
    canvas.drawArc(rect, 0, -3.14159265359, false, bgPaint); // half ellipse

    // Draw the progress
    canvas.drawArc(rect, -3.14159265359, 3.14159265359 * progress, false, progressPaint);
  }

  @override
  bool shouldRepaint(covariant _HorizontalEllipseGaugePainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor;
  }
}
