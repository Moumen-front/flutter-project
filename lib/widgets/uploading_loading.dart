import 'dart:math';
import 'package:flutter/material.dart';

import 'loading_text.dart';



class CircularLoadingIndicator extends StatefulWidget {
  final double size;
  final Duration rotationSpeed;

  final double strokeWidth;
  final double strokeLength;
  final int segmentCount;

  final Color color;

  final  String text;
  final TextStyle? textStyle;

  final Duration flickerSpeed;
  final Duration dotsSpeed;

  const CircularLoadingIndicator({
    super.key,
    this.size = 250,
    this.rotationSpeed = const Duration(milliseconds: 600),
    this.strokeWidth = 3,
    this.strokeLength = 20,
    this.segmentCount = 120,
    this.color = Colors.teal,
    required this.text ,
    this.textStyle,
    this.flickerSpeed = const Duration(milliseconds: 450),
    this.dotsSpeed = const Duration(milliseconds: 1480),
  });

  @override
  State<CircularLoadingIndicator> createState() =>
      _CircularLoadingIndicatorState();
}

class _CircularLoadingIndicatorState extends State<CircularLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.rotationSpeed,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (_, _) {
              return CustomPaint(
                size: Size(widget.size, widget.size),
                painter: _SegmentedCirclePainter(
                  progress: _controller.value,
                  strokeWidth: widget.strokeWidth,
                  strokeLength: widget.strokeLength,
                  segmentCount: widget.segmentCount,
                  color: widget.color,
                ),
              );
            },
          ),
          AnimatedLoadingText(
            text: widget.text,
            style: widget.textStyle ??
                Theme.of(context).textTheme.bodyMedium,
            flickerSpeed: widget.flickerSpeed,
            dotsSpeed: widget.dotsSpeed,
          ),
        ],
      ),
    );
  }
}


class _SegmentedCirclePainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final double strokeLength;
  final int segmentCount;
  final Color color;

  _SegmentedCirclePainter({
    required this.progress,
    required this.strokeWidth,
    required this.strokeLength,
    required this.segmentCount,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);

    final paint = Paint()
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    for (int i = 0; i < segmentCount; i++) {
      final angle =
          (2 * pi / segmentCount) * i + (2 * pi * progress);
      final opacity = i / segmentCount;

      paint.color = color.withValues(alpha:  opacity);

      final startRadius = radius - strokeLength;

      final start = Offset(
        center.dx + cos(angle) * startRadius,
        center.dy + sin(angle) * startRadius,
      );

      final end = Offset(
        center.dx + cos(angle) * radius,
        center.dy + sin(angle) * radius,
      );

      canvas.drawLine(start, end, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SegmentedCirclePainter oldDelegate) => true;
}
