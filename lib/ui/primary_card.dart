import 'package:flutter/cupertino.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/helpers/theme.dart';
import 'package:frontend/ui/themed/themed_card.dart';

class PrimaryCard extends StatelessWidget {
  const PrimaryCard({
    super.key,
    this.padding = AppPadding.sm,
    this.onTap,
    required this.child,
  });

  const PrimaryCard.medium({
    super.key,
    this.padding = AppPadding.md,
    this.onTap,
    required this.child,
  });

  const PrimaryCard.large({
    super.key,
    this.padding = AppPadding.lg,
    this.onTap,
    required this.child,
  });

  final double padding;

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ThemedCard(
      padding: padding,
      onTap: onTap,
      color: CustomCupertinoTheme.of(context).primaryColor,
      shadowColor: CustomCupertinoTheme.of(context).bgColor2,
      child: child,
    );
  }
}
