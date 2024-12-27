import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

const Level loggerLevel = Level.trace;

/// Logger for the app.
Logger logger = Logger(
  /// Logger level.
  printer: PrettyPrinter(
    methodCount: 1,
    errorMethodCount: 5,
    lineLength: 90,
    colors: false,
    printEmojis: true,
  ),
  level: loggerLevel,
);

/// Extends 'LogOutput' to correctly display console colors on macOS systems.
///
/// The behavior is determined by the application's run mode (Release or Debug)
/// and the operating platform (iOS or non-iOS).
///
/// For more information, see: https://github.com/simc/logger/issues/1#issuecomment-1582076726
class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    if (kReleaseMode || !Platform.isIOS) {
      event.lines.forEach(debugPrint);
    } else {
      event.lines.forEach(debugPrint);
    }
  }
}
