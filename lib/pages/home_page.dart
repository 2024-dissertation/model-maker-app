import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/collections/cubit/collection_cubit.dart';
import 'package:frontend/module/collections/models/collection.dart';
import 'package:frontend/module/home/cubit/home_cubit.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';
import 'package:frontend/ui/error_card.dart';
import 'package:frontend/ui/modals/select_collection_modal.dart';
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
                      child: Center(
                          child: ThemedText(
                    "No models scanned",
                    color: TextColor.muted,
                  )))
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
                                  '/authed/home/task/${task.id}',
                                ),
                                onLongTap: () async {
                                  final action =
                                      await _showActionSheet(context);
                                  if (action == 1) {
                                    final TextEditingController controller =
                                        TextEditingController(
                                      text: task.fTitle,
                                    );
                                    final data =
                                        await showCupertinoDialog<bool?>(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text('Rename Model'),
                                          content: CupertinoTextField(
                                            controller: controller,
                                          ),
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
                                              isDefaultAction: true,
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (data == true) {
                                      context.read<HomeCubit>().updateTask(
                                            task.copyWith(
                                              title: controller.text,
                                            ),
                                          );
                                    }
                                  } else if (action == 2) {
                                    final TextEditingController controller =
                                        TextEditingController(
                                      text: task.fTitle,
                                    );
                                    final data =
                                        await showCupertinoDialog<bool?>(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text('Change Summary'),
                                          content: CupertinoTextField(
                                            controller: controller,
                                          ),
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
                                              isDefaultAction: true,
                                              child: const Text('Save'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                    if (data == true) {
                                      context.read<HomeCubit>().updateTask(
                                            task.copyWith(
                                              description: controller.text,
                                            ),
                                          );
                                    }
                                  } else if (action == 3) {
                                    final data =
                                        await showCupertinoSheet<Collection?>(
                                            context: context,
                                            useNestedNavigation: true,
                                            pageBuilder:
                                                (BuildContext context) =>
                                                    SelectCollectionModal());
                                    logger.d(data);

                                    if (data != null) {
                                      context
                                          .read<CollectionCubit>()
                                          .saveCollection(data.copyWith(
                                            tasks: [
                                              ...data.tasks ?? [],
                                              task,
                                            ],
                                          ));
                                    }
                                  } else if (action == 4) {
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
                                              _taskRepository
                                                  .deleteTask(task.id);
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
        title: const Text('Task'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () {
              context.pop(1);
            },
            child: const Text('Edit Title'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              context.pop(2);
            },
            child: const Text('Edit Description'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              context.pop(3);
            },
            child: const Text('Add to Collection'),
          ),
          CupertinoActionSheetAction(
            onPressed: () {
              context.pop(4);
            },
            isDefaultAction: true,
            isDestructiveAction: true,
            child: const Text('Re-run'),
          ),
        ],
      ),
    );
  }
}
