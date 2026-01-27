import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

class MicButton extends StatefulWidget {
  final Stream<double> amplitudeStream;
  final bool isRecording;
  final VoidCallback? onTap;


  const MicButton({
    super.key,
    required this.amplitudeStream,
    required this.isRecording,
    this.onTap,
  });

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  StreamSubscription<double>? _amplitudeSubscription;
  double _amplitude = 0.0;

  @override
  void initState() {
    super.initState();

    // small pulsing animation even if amplitude is low
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);

    // listen to amplitude stream
     _amplitudeSubscription = widget.amplitudeStream.listen((amp) {
      setState(() {
        _amplitude = amp;
      });
    });
  }

  @override
  void didUpdateWidget(covariant MicButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isRecording) {
      if (!_controller.isAnimating) _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final baseSize = 80.0;
          final waveCount = 3;
          final waveSpacing = 15.0;

          return SizedBox(
            width: baseSize + waveCount * waveSpacing * 2,
            height: baseSize + waveCount * waveSpacing * 2,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // waves
                for (int i = 1; i <= waveCount; i++)
                  Container(
                    width: baseSize + i * waveSpacing * (1 + _amplitude),
                    height: baseSize + i * waveSpacing * (1 + _amplitude),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.cyan.withOpacity(0.3 / i),
                    ),
                  ),
                // base mic icon
                Container(
                  width: baseSize,
                  height: baseSize,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.cyan,
                  ),
                  child: Icon(
                    widget.isRecording ? Icons.mic_none : Icons.mic,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _amplitudeSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }
}
