import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/ui/task_status_widget.dart';

void main() {
  testWidgets('task status widget golden test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: TaskStatusWidget(
          status: Task.empty,
        ),
      ),
    );
    await expectLater(find.byType(TaskStatusWidget),
        matchesGoldenFile('TaskStatusWidget.png'));
  });
}
