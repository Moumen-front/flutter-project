

import 'package:flutter/cupertino.dart';

class BottomRevealClipper extends CustomClipper<Rect> {
  final double visibleFraction; // 0.0 → 1.0

  BottomRevealClipper(this.visibleFraction);

  @override
  Rect getClip(Size size) {
    final visibleHeight = size.height * visibleFraction;

    return Rect.fromLTWH(
      0,
      size.height - visibleHeight, // bottom anchored
      size.width,
      visibleHeight,
    );
  }

  @override
  bool shouldReclip(covariant BottomRevealClipper oldClipper) {
    return oldClipper.visibleFraction != visibleFraction;
  }
}
