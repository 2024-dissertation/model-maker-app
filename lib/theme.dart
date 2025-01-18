import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

CupertinoThemeData createCupertinoThemeFromSeed(Color seedColor) {
  final colorScheme = ColorScheme.fromSeed(seedColor: seedColor);

  return CupertinoThemeData(
    primaryColor: colorScheme.primary,
    primaryContrastingColor: colorScheme.onPrimary,
    barBackgroundColor: colorScheme.surface,
    scaffoldBackgroundColor: colorScheme.surface,
    textTheme: CupertinoTextThemeData(
      textStyle: TextStyle(color: colorScheme.onSurface),
      actionTextStyle: TextStyle(color: colorScheme.primary),
      tabLabelTextStyle: TextStyle(color: colorScheme.primary),
    ),
  );
}
