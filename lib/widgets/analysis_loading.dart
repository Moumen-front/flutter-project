import 'package:flutter/material.dart';
import 'loading_text.dart';

class AnalysisLoadingIndicator extends StatefulWidget {
  final double width;
  final double height;

  final Color backgroundColor;
  final Color progressColor;

  final BorderRadius borderRadius;

  final Duration progressSpeed;

  final String text;
  final TextStyle? textStyle;
  final Duration flickerSpeed;
  final Duration dotsSpeed;

  const AnalysisLoadingIndicator({
    super.key,
    this.width = 160,
    this.height = 20,
    this.backgroundColor = const Color.fromARGB(255, 216, 236, 233),
    this.progressColor = const Color.fromARGB(255, 115, 210, 196),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.progressSpeed = const Duration(seconds: 1),
    this.text = 'Analysis in progress',
    this.textStyle,
    this.flickerSpeed = const Duration(milliseconds: 450),
    this.dotsSpeed = const Duration(milliseconds: 1480),
  });

  @override
  State<AnalysisLoadingIndicator> createState() =>
      _AnalysisLoadingIndicatorState();
}

class _AnalysisLoadingIndicatorState extends State<AnalysisLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.progressSpeed,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: widget.borderRadius,
          ),
          child: ClipRRect(
            borderRadius: widget.borderRadius,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (_, __) {
                return Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    width: widget.width * _controller.value,
                    height: widget.height,
                    decoration: BoxDecoration(
                      color: widget.progressColor,
                      borderRadius: widget.borderRadius,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: AnimatedLoadingText(
            text: widget.text,
            style: widget.textStyle ??
                Theme.of(context).textTheme.bodyMedium,
            flickerSpeed: widget.flickerSpeed,
            dotsSpeed: widget.dotsSpeed,
          ),
        ),
      ],
    );
  }
}
