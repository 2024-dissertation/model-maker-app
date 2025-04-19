import 'package:flutter/material.dart';
import 'package:frontend/ui/themed/themed_text.dart';

class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        ThemedText(
          text,
          weight: FontWeight.w600,
        )
      ],
    );
  }
}
