import 'package:flutter/material.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/helpers/theme.dart';

class ThemedCard extends StatelessWidget {
  const ThemedCard({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.color,
    this.shadowColor,
    this.padding = AppPadding.sm,
    this.outlined = false,
  });

  const ThemedCard.large({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.color,
    this.shadowColor,
    this.outlined = false,
  }) : padding = AppPadding.lg;

  const ThemedCard.medium({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.color,
    this.shadowColor,
    this.outlined = false,
  }) : padding = AppPadding.md;

  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  final Color? color;
  final Color? shadowColor;

  final double padding;

  final bool outlined;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color ?? CustomCupertinoTheme.of(context).card,
      borderRadius: BorderRadius.all(Radius.circular(AppPadding.sm)),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(AppPadding.sm)),
        onTap: onTap,
        onLongPress: onLongPress,
        child: Container(
          decoration: BoxDecoration(
            color: outlined ? Colors.transparent : color,
            borderRadius: BorderRadius.all(Radius.circular(AppPadding.sm)),
            border: outlined
                ? Border.all(
                    color: CustomCupertinoTheme.of(context).primaryColor,
                    width: 4.0,
                  )
                : null,
          ),
          child: Container(
            padding: EdgeInsets.all(padding),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(AppPadding.sm)),
              border: Border(
                bottom: BorderSide(
                  color: shadowColor ??
                      CustomCupertinoTheme.of(context).cardShadow,
                  width: 4.0,
                ),
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}
