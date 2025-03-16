import 'package:flutter/cupertino.dart';
import 'package:frontend/helpers/theme.dart';

enum TextType {
  body,
  title,
  subtitle,
}

enum TextColor {
  primary,
  secondary,
}

class ThemedText extends StatelessWidget {
  const ThemedText(
    this.text, {
    super.key,
    this.style = TextType.body,
    this.color = TextColor.primary,
  });

  final TextType style;
  final TextColor color;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _getTextType(context),
    );
  }

  TextStyle _getTextType(BuildContext context) {
    switch (style) {
      case TextType.body:
        return CustomCupertinoTheme.of(context).body.copyWith(
              color: _getTextColor(context),
            );
      case TextType.title:
        return CustomCupertinoTheme.of(context).title.copyWith(
              color: _getTextColor(context),
            );
      case TextType.subtitle:
        return CustomCupertinoTheme.of(context).subtitle.copyWith(
              color: _getTextColor(context),
            );
    }
  }

  Color _getTextColor(BuildContext context) {
    final brightness = MediaQuery.of(context).platformBrightness;
    switch (color) {
      case TextColor.primary:
        return brightness == Brightness.dark
            ? CupertinoColors.white
            : raisinBlack;
      case TextColor.secondary:
        return brightness == Brightness.dark
            ? CupertinoColors.systemGrey
            : desaturatedPink;
    }
  }
}
