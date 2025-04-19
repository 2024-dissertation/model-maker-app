import 'package:flutter/cupertino.dart';

class ThemedIcon extends StatelessWidget {
  const ThemedIcon({super.key, this.icon, this.size, this.color});

  final IconData? icon;
  final double? size;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size ?? 20,
      color: color ?? CupertinoTheme.of(context).primaryColor,
    );
  }
}
