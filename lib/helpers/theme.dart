import 'package:flutter/cupertino.dart';

const raisinBlack = Color(0xFF1E1E24);

const coralPink = Color(0xFFFB9F89);
const coralPinkDark = Color(0xFFE07A5F);

const khaki = Color(0xFFC4AF9A);
const khakiDark = Color(0xFFA18C7A);

const cambridgeBlue = Color(0xFF81AE9D);
const cambridgeBlueDark = Color(0xFF5E7D6B);

const jungleGreen = Color(0xFF21A179);
const jungleGreenDark = Color(0xFF1A7A5A);

const desaturatedPink = Color(0xFFae8781);
const desaturatedPinkDark = Color(0xFF7a5a54);

const desaturatedDarkViolet = Color(0xFF9d81ae);
const desaturatedDarkVioletDark = Color(0xFF6b5a7d);

const CupertinoThemeData cupertinoLight = CupertinoThemeData(
  brightness: Brightness.light,
  primaryColor: CupertinoColors.activeBlue,
  scaffoldBackgroundColor: cambridgeBlue,
);

const CupertinoThemeData cupertinoDark = CupertinoThemeData(
  brightness: Brightness.dark,
  primaryColor: CupertinoColors.activeGreen,
  scaffoldBackgroundColor: raisinBlack,
);

class CustomCupertinoTheme extends CupertinoThemeData {
  final TextStyle body;
  final TextStyle title;
  final TextStyle subtitle;

  final Color bgColor1;
  final Color bgColor2;
  final Color bgColor3;

  const CustomCupertinoTheme({
    required this.body,
    required this.title,
    required this.subtitle,
    required this.bgColor1,
    required this.bgColor2,
    required this.bgColor3,
  }) : super();

  static CustomCupertinoTheme of(BuildContext context) {
    final theme = CupertinoTheme.of(context);

    if (theme.brightness == Brightness.dark) {
      return CustomCupertinoTheme(
        body: theme.textTheme.textStyle.copyWith(fontSize: 16),
        title: theme.textTheme.textStyle
            .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
        subtitle: theme.textTheme.textStyle.copyWith(fontSize: 20),
        bgColor1: raisinBlack,
        bgColor2: desaturatedDarkVioletDark,
        bgColor3: cambridgeBlue,
      );
    }

    return CustomCupertinoTheme(
      body: theme.textTheme.textStyle.copyWith(fontSize: 16),
      title: theme.textTheme.textStyle
          .copyWith(fontSize: 32, fontWeight: FontWeight.bold),
      subtitle: theme.textTheme.textStyle.copyWith(fontSize: 20),
      bgColor1: cambridgeBlue,
      bgColor2: desaturatedDarkViolet,
      bgColor3: cambridgeBlue,
    );
  }
}
