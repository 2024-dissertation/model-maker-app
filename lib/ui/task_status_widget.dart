import 'package:flutter/material.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/module/tasks/models/task_status.dart';

class TaskStatusWidget extends StatelessWidget {
  final Task task;

  const TaskStatusWidget({super.key, required this.task});

  @override
  Widget build(BuildContext context) {
    return Badge(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      backgroundColor: task.status.color,
      label: Text(task.status.label),
    );
  }
}
