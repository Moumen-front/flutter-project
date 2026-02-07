import 'dart:math';
import 'package:flutter/material.dart';

class AnimatedLoadingText extends StatefulWidget {
  final String text;
  final TextStyle? style;

  final Duration flickerSpeed;
  final Duration dotsSpeed;
  final int maxDots;

  const AnimatedLoadingText({
    super.key,
    required this.text,
    this.style,
    this.flickerSpeed = const Duration(milliseconds: 1400),
    this.dotsSpeed = const Duration(milliseconds: 500),
    this.maxDots = 3,
  });

  @override
  State<AnimatedLoadingText> createState() => _AnimatedLoadingTextState();
}

class _AnimatedLoadingTextState extends State<AnimatedLoadingText>
    with TickerProviderStateMixin {
  late final AnimationController _flickerController;
  late final AnimationController _dotsController;

  @override
  void initState() {
    super.initState();

    _flickerController = AnimationController(
      vsync: this,
      duration: widget.flickerSpeed,
    )..repeat(reverse: true);

    _dotsController = AnimationController(
      vsync: this,
      duration: widget.dotsSpeed,
    )..repeat();
  }

  @override
  void dispose() {
    _flickerController.dispose();
    _dotsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        _flickerController,
        _dotsController,
      ]),
      builder: (_, _) {
        // Discrete dots: 1 → maxDots
        final dots =
            (_dotsController.value * (widget.maxDots+1)).floor() ;

        // Smooth flicker (never fully off)
        final opacity = 0.6 +
            0.4 * sin(_flickerController.value * pi);

        return Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: Text(
            '${widget.text}${'.' * dots}'.padRight(
              widget.text.length + (widget.maxDots+1),
            ),
            style: widget.style ??
                Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
    );
  }
}
