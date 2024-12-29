import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/home/cubit/home_cubit.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => HomeCubit()..fetchTasks(),
      child: const _HomePage(),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Home Route'),
      ),
      child: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: SafeArea(
          child: Center(
            child: BlocBuilder<HomeCubit, HomeState>(
              builder: (context, state) {
                if (state is HomeLoaded) {
                  return CustomScrollView(
                    slivers: [
                      CupertinoSliverRefreshControl(
                        onRefresh: () => context.read<HomeCubit>().fetchTasks(),
                      ),
                      SliverPadding(
                        padding: const EdgeInsets.all(16),
                        sliver: SliverToBoxAdapter(
                          child: CupertinoSearchTextField(
                            onChanged: (value) =>
                                context.read<HomeCubit>().searchTasks(value),
                          ),
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            return Dismissible(
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
                                        state.filteredTasks[index].id,
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
                                "${state.filteredTasks[index].hashCode}",
                              ),
                              child: CupertinoListTile(
                                title: Text(state.filteredTasks[index].title),
                                subtitle: Text(
                                    state.filteredTasks[index].description),
                                onTap: () {
                                  context.go(
                                    '/authed/home/task',
                                    extra: state.filteredTasks[index],
                                  );
                                },
                              ),
                            );
                          },
                          childCount: state.filteredTasks.length,
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
          ),
        ),
      ),
    );
  }
}
