import 'package:flutter/material.dart';
import 'package:frontend/helpers/theme.dart';

class DotIndicator extends StatelessWidget {
  final int itemCount;
  final int currentIndex;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;

  const DotIndicator({
    super.key,
    required this.itemCount,
    required this.currentIndex,
    this.activeColor = raisinBlack,
    this.inactiveColor = desaturatedPink,
    this.dotSize = 8.0,
    this.spacing = 6.0,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: List.generate(itemCount, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: currentIndex == index ? dotSize * 2.0 : dotSize,
          height: dotSize,
          decoration: BoxDecoration(
            color: currentIndex == index ? activeColor : inactiveColor,
            borderRadius: BorderRadius.circular(dotSize),
          ),
        );
      }),
    );
  }
}
