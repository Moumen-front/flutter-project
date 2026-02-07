import 'package:flutter/material.dart';

import 'gauge.dart';



class GaugeWithCenterWidget extends StatelessWidget {
  final double width;
  final double height;
  final double progress; // 0.0 → 1.0
  final Widget centerWidget;
  final Color backgroundColor;
  final Color progressColor;
  final double strokeWidth;

  const GaugeWithCenterWidget({
    super.key,
    required this.width,
    required this.height,
    required this.progress,
    required this.centerWidget,
    this.backgroundColor = const Color(0xFFE0E0E0),
    this.progressColor = Colors.green,
    this.strokeWidth = 10.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: width,
        height: height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            HorizontalEllipseGauge(
              width: width,
              height: height,
              progress: progress.clamp(0.0, 1.0),
              backgroundColor: backgroundColor,
              progressColor: progressColor,
              strokeWidth: strokeWidth,
            ),
            Positioned(bottom: height*0.25,child: centerWidget),
          ],
        ),
      ),
    );
  }
}
