import 'package:dart_mappable/dart_mappable.dart';
import 'package:flutter/cupertino.dart';

part 'task_status.mapper.dart';

@MappableEnum()
enum TaskStatus {
  SUCCESS,
  INPROGRESS,
  FAILED,
  INITIAL,
  UNKNOWN,
}

extension TaskStatusX on TaskStatus {
  Color get color {
    switch (this) {
      case TaskStatus.SUCCESS:
        return CupertinoColors.activeGreen;

      case TaskStatus.INITIAL:
        return CupertinoColors.systemGrey;

      case TaskStatus.INPROGRESS:
        return CupertinoColors.activeBlue;

      case TaskStatus.FAILED:
        return CupertinoColors.systemRed;

      default:
        return CupertinoColors.systemGrey;
    }
  }

  String get label {
    switch (this) {
      case TaskStatus.SUCCESS:
        return "Completed";

      case TaskStatus.INITIAL:
        return "Not started";

      case TaskStatus.INPROGRESS:
        return "In Progress";

      case TaskStatus.FAILED:
        return "Failed";

      default:
        return "Not started";
    }
  }
}
