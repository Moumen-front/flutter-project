import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';


class AnimatedTextButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final Widget? child;
  final String? text;

  // Optional custom colors
  final Color? normalColor;
  final Color? hoverColor;
  final Color? pressedColor;
  final Color? disabledColor;
  final Color? backgroundColor;

  const AnimatedTextButton({
    super.key,
    required this.onPressed,
    this.child,
    this.text,
    this.normalColor,
    this.hoverColor,
    this.pressedColor,
    this.disabledColor,
    this.backgroundColor,
  });

  @override
  State<AnimatedTextButton> createState() => _AnimatedTextButtonState();
}

class _AnimatedTextButtonState extends State<AnimatedTextButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) => setState(() => _scale = 0.9);

  void _onTapUp(TapUpDetails details) => setState(() => _scale = 1.0);

  void _onTapCancel() => setState(() => _scale = 1.0);

  void _onHover(bool hovering) => setState(() => _scale = hovering ? 1.1 : 1.0);

  @override
  Widget build(BuildContext context) {
    final ButtonStyle defaultStyle =
        Theme.of(context).textButtonTheme.style ??
            TextButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              textStyle: const TextStyle(fontSize: 18),
            );

    // Wrap the style so we can override colors but keep the default style
    final ButtonStyle style = defaultStyle.copyWith(
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
            (states) {
          if (states.contains(WidgetState.disabled))
            return widget.disabledColor ?? Colors.black26;
          if (states.contains(WidgetState.hovered))
            return widget.hoverColor ?? widget.normalColor;
          if (states.contains(WidgetState.pressed))
            return widget.pressedColor ?? widget.normalColor;
          return widget.normalColor;
        },
      ),
      backgroundColor: WidgetStateProperty.all(widget.backgroundColor),
    );

    return MouseRegion(
      onEnter: (_) => _onHover(true),
      onExit: (_) => _onHover(false),
      child: GestureDetector(
        onTap: widget.onPressed,
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        child: AnimatedScale(
          scale: _scale,
          duration: const Duration(milliseconds: 100),
          curve: Curves.easeInOut,
          child: TextButton(
            onPressed: widget.onPressed,
            style: style,
            child: widget.child ??
                AutoSizeText(
                  widget.text ?? "",
                  maxFontSize: 50,
                  minFontSize: 10,
                  maxLines: 1,
                ),
          ),
        ),
      ),
    );
  }
}

