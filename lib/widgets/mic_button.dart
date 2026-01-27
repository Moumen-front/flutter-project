import 'package:flutter/material.dart';

class MicButton extends StatefulWidget {
  // نستقبل الحالة من الخارج
  final bool isRecording;
  // نستقبل حدث الضغط من الخارج
  final VoidCallback onTap;

  const MicButton({
    super.key,
    required this.isRecording,
    required this.onTap,
  });

  @override
  State<MicButton> createState() => _MicButtonState();
}

class _MicButtonState extends State<MicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant MicButton oldWidget) {
    super.didUpdateWidget(oldWidget);

    // إذا الحالة تغيرت من الخارج → شغّل الأنيميشن أو أوقفه
    if (widget.isRecording) {
      _controller.repeat(reverse: true);
    } else {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // الضغط يأتي من الخارج
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.isRecording ? Colors.cyan: Color.fromARGB(255,187, 70, 72),
          ),
          child: Icon(
            widget.isRecording ? Icons.mic_none : Icons.mic,
            size: 80,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

//to not cause memory leak
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
