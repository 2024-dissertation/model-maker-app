import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/module/home/cubit/home_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';
import 'package:frontend/ui/error_card.dart';
import 'package:frontend/ui/themed/themed_list_item.dart';
import 'package:frontend/ui/task_status_widget.dart';
import 'package:frontend/ui/themed/themed_text.dart';
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
                  largeTitle: const Text(
                    'Home',
                  ),
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
                      child: Center(child: ThemedText("No jobs created")))
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.md),
                    sliver: SliverList.list(
                      children: state.filteredTasks
                          .map(
                            (task) => Container(
                              margin: EdgeInsets.only(bottom: AppPadding.sm),
                              child: ThemedListItem(
                                trailing: TaskStatusWidget(status: task.status),
                                onTap: () => context.go(
                                  '/authed/home/task',
                                  extra: task,
                                ),
                                onLongTap: () async {
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
                                onDismissed: () =>
                                    context.read<HomeCubit>().removeTask(
                                          task.id,
                                        ),
                                dismissableKey: "${task.id}",
                                title: ThemedText(task.fTitle,
                                    style: TextType.title, size: 16),
                                subtitle: ThemedText(
                                  task.fDescription,
                                  style: TextType.small,
                                  color: TextColor.secondary,
                                ),
                                onConfirmDismiss: () async {
                                  final result = await showCupertinoDialog(
                                    context: context,
                                    builder: (context) {
                                      return CupertinoAlertDialog(
                                        title: const ThemedText('Delete Task'),
                                        content: const ThemedText(
                                            'Are you sure you want to delete this task?'),
                                        actions: [
                                          CupertinoDialogAction(
                                            onPressed: () {
                                              context.pop(false);
                                            },
                                            child: const ThemedText('Cancel'),
                                          ),
                                          CupertinoDialogAction(
                                            onPressed: () {
                                              context.pop(true);
                                            },
                                            isDestructiveAction: true,
                                            child: const ThemedText('Delete'),
                                          ),
                                        ],
                                      );
                                    },
                                  );

                                  return result ?? false;
                                },
                              ),
                            ),
                            // child: CupertinoListTile(
                            //   title: Text(task.title),
                            //   subtitle: Text(task.description),
                            //   onTap: () async {
                            //     final action =
                            //         await _showActionSheet(context);
                            //     if (action == 1) {
                            //       context.go(
                            //         '/authed/home/task',
                            //         extra: task,
                            //       );
                            //     } else if (action == 2) {
                            //       _taskRepository.startTask(task.id);
                            //     }
                            //   },
                            //   trailing: TaskStatusWidget(task: task),
                            // ),
                            // ),
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
            return Center(
              child: ErrorCard(
                state.message,
                onRetry: () => context.read<HomeCubit>().fetchTasks(),
              ),
            );
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
        title: const ThemedText('Title'),
        message: const ThemedText('Message'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            /// This parameter indicates the action would be a default
            /// default behavior, turns the action's text to bold text.
            isDefaultAction: true,
            onPressed: () {
              context.pop(1);
            },
            child: const ThemedText('View'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              context.pop(2);
            },
            isDestructiveAction: true,
            child: const ThemedText('Re-run'),
          ),
        ],
      ),
    );
  }
}
