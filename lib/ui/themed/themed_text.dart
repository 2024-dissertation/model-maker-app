import 'package:flutter/cupertino.dart';
import 'package:frontend/helpers/theme.dart';
import 'package:google_fonts/google_fonts.dart';

enum TextType {
  body,
  title,
  subtitle,
  small,
  blank,
}

enum TextColor {
  primary,
  secondary,
  inverse,
  white,
  success,
  warning,
  muted,
}

class ThemedText extends StatelessWidget {
  const ThemedText(
    this.text, {
    super.key,
    this.style = TextType.body,
    this.color = TextColor.primary,
    this.size,
    this.weight,
  });

  final TextType style;
  final TextColor color;

  final double? size;
  final FontWeight? weight;

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: _getTextType(context)?.copyWith(fontSize: size),
    );
  }

  TextStyle? _getTextType(BuildContext context) {
    if (weight != null) {
      return CustomCupertinoTheme.of(context).body.copyWith(
            fontSize: size,
            fontWeight: weight,
            color: _getTextColor(context),
          );
    }

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
      case TextType.small:
        return CustomCupertinoTheme.of(context).body.copyWith(
              fontSize: 14,
              color: _getTextColor(context),
            );
      case TextType.blank:
        return GoogleFonts.openSans();
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
      case TextColor.inverse:
        return brightness == Brightness.dark
            ? raisinBlack
            : CupertinoColors.white;
      case TextColor.white:
        return CupertinoColors.white;
      case TextColor.success:
        return CupertinoColors.activeGreen;
      case TextColor.warning:
        return CupertinoColors.systemPink;
      case TextColor.muted:
        return CupertinoColors.systemGrey;
    }
  }
}
