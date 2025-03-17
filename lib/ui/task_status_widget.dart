import 'package:flutter/material.dart';
import 'package:frontend/module/tasks/models/task_status.dart';

class TaskStatusWidget extends StatelessWidget {
  final TaskStatus status;

  const TaskStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Badge(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      backgroundColor: status.color,
      label: Text(status.label),
    );
  }
}
