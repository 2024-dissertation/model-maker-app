import 'package:flutter/cupertino.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/ui/themed/themed_card.dart';

class DangerCard extends StatelessWidget {
  const DangerCard({
    super.key,
    this.padding = AppPadding.sm,
    this.onTap,
    required this.child,
  });

  const DangerCard.medium({
    super.key,
    this.padding = AppPadding.md,
    this.onTap,
    required this.child,
  });

  const DangerCard.large({
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
      onTap: onTap,
      padding: padding,
      color: CupertinoColors.systemRed,
      shadowColor: CupertinoColors.systemBrown,
      child: child,
    );
  }
}
