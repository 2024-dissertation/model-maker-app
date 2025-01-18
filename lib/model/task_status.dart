import 'package:flutter/cupertino.dart';

enum TaskStatus {
  success("SUCCESS"),
  inProgress("INPROGRESS"),
  failed("FAILED"),
  initial("INITIAL"),
  unknown("UNKNOWN");

  final String name;

  const TaskStatus(this.name);
}

extension TaskStatusX on TaskStatus {
  static TaskStatus fromName(String name) {
    switch (name) {
      case "SUCCESS":
        return TaskStatus.success;
      case "INPROGRESS":
        return TaskStatus.inProgress;
      case "FAILED":
        return TaskStatus.failed;
      case "INITIAL":
        return TaskStatus.initial;
      default:
        return TaskStatus.unknown;
    }
  }

  Color get color {
    switch (this) {
      case TaskStatus.success:
        return CupertinoColors.activeGreen;

      case TaskStatus.inProgress:
        return CupertinoColors.activeBlue;

      case TaskStatus.failed:
        return CupertinoColors.systemRed;

      case TaskStatus.initial:
      default:
        return CupertinoColors.systemGrey;
    }
  }

  String get label {
    switch (this) {
      case TaskStatus.success:
        return "Completed";

      case TaskStatus.inProgress:
        return "In Progress";

      case TaskStatus.failed:
        return "Failed";

      case TaskStatus.initial:
      default:
        return "Not started";
    }
  }
}
