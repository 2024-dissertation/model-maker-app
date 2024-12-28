import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/model/task.dart';
import 'package:frontend/view_task/cubit/view_task_cubit.dart';
import 'package:frontend/view_task/widgets/mage_carousel.dart';

class ViewTask extends StatelessWidget {
  const ViewTask({
    super.key,
    this.task,
    this.taskId,
  });

  final Task? task;
  final int? taskId;

  @override
  Widget build(BuildContext context) {
    if (task == null && taskId == null) {
      throw Exception("Task or taskId must be provided");
    }

    if (task != null) {
      return BlocProvider(
        create: (_) => ViewTaskCubit.preLoaded(task!),
        child: _ViewTask(),
      );
    }

    return BlocProvider(
      create: (_) => ViewTaskCubit(taskId!),
      child: _ViewTask(),
    );
  }
}

class _ViewTask extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Task'),
      ),
      child: SafeArea(
        child: Center(
          child: BlocBuilder<ViewTaskCubit, ViewTaskState>(
              builder: (context, state) {
            if (state is ViewTaskError) {
              return Text(state.message);
            }

            if (state is ViewTaskLoading) {
              return const CupertinoActivityIndicator();
            }

            if (state is ViewTaskLoaded) {
              return Column(
                children: [
                  Text(state.task.title),
                  Text(state.task.description),
                  CarouselDemo(task: state.task),
                ],
              );
            }

            return const SizedBox();
          }),
        ),
      ),
    );
  }
}
