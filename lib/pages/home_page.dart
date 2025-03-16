import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/module/home/cubit/home_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';
import 'package:frontend/ui/task_status_widget.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..fetchTasks(),
      child: _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  _HomePage();

  final TaskRepository _taskRepository = getIt();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state is HomeLoaded) {
            return CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: const Text('Home'),
                  trailing: IconButton(
                    iconSize: 20,
                    icon: const Icon(CupertinoIcons.add),
                    onPressed: () {
                      context.go('/authed/new');
                    },
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(35),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: CupertinoSearchTextField(
                        onChanged: (value) =>
                            context.read<HomeCubit>().searchTasks(value),
                      ),
                    ),
                  ),
                ),
                CupertinoSliverRefreshControl(
                  onRefresh: () => context.read<HomeCubit>().fetchTasks(),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 16,
                  ),
                ),
                if (state.tasks.isEmpty)
                  const SliverToBoxAdapter(
                      child: Center(child: Text("No jobs created")))
                else
                  SliverFillRemaining(
                    child: CupertinoListSection(
                      header: const Text('Tasks'),
                      children: state.filteredTasks
                          .map(
                            (task) => Dismissible(
                              direction: DismissDirection.endToStart,
                              background: Container(
                                color: CupertinoColors.systemRed,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16),
                                child: const Icon(
                                  CupertinoIcons.delete,
                                  color: CupertinoColors.white,
                                ),
                              ),
                              onDismissed: (direction) =>
                                  context.read<HomeCubit>().removeTask(
                                        task.id,
                                      ),
                              confirmDismiss: (_) async {
                                final result = await showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: const Text('Delete Task'),
                                      content: const Text(
                                          'Are you sure you want to delete this task?'),
                                      actions: [
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            context.pop(false);
                                          },
                                          child: const Text('Cancel'),
                                        ),
                                        CupertinoDialogAction(
                                          onPressed: () {
                                            context.pop(true);
                                          },
                                          isDestructiveAction: true,
                                          child: const Text('Delete'),
                                        ),
                                      ],
                                    );
                                  },
                                );

                                return result ?? false;
                              },
                              key: Key(
                                "${task.id}",
                              ),
                              child: CupertinoListTile(
                                title: Text(task.title),
                                subtitle: Text(task.description),
                                onTap: () async {
                                  final action =
                                      await _showActionSheet(context);
                                  if (action == 1) {
                                    context.go(
                                      '/authed/home/task',
                                      extra: task,
                                    );
                                  } else if (action == 2) {
                                    _taskRepository.startTask(task.id);
                                  }
                                },
                                trailing: TaskStatusWidget(task: task),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                const SliverToBoxAdapter(
                  child: SizedBox(
                    height: 128,
                  ),
                ),
              ],
            );
          } else if (state is HomeError) {
            return Text(state.message);
          } else {
            return const CupertinoActivityIndicator();
          }
        },
      ),
    );
  }

  Future<int?> _showActionSheet(BuildContext context) {
    return showCupertinoModalPopup<int>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Title'),
        message: const Text('Message'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              context.pop(1);
            },
            child: const Text('View'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              context.pop(2);
            },
            isDestructiveAction: true,
            child: const Text('Re-run'),
          ),
        ],
      ),
    );
  }
}
