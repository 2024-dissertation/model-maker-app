import 'package:flutter/material.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/helpers/theme.dart';

class ThemedCard extends StatelessWidget {
  const ThemedCard({
    super.key,
    required this.child,
    this.onTap,
    this.color,
    this.shadowColor,
  });

  final Widget child;
  final VoidCallback? onTap;

  final Color? color;
  final Color? shadowColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? CustomCupertinoTheme.of(context).card,
      borderRadius: BorderRadius.all(Radius.circular(AppPadding.sm)),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(AppPadding.sm)),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppPadding.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(AppPadding.sm)),
            border: Border(
              bottom: BorderSide(
                color:
                    shadowColor ?? CustomCupertinoTheme.of(context).cardShadow,
                width: 4.0,
              ),
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
