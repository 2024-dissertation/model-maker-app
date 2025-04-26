import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/collections/cubit/collection_cubit.dart';
import 'package:frontend/ui/collection_card.dart';
import 'package:frontend/ui/modals/create_collection_modal.dart';
import 'package:frontend/ui/danger_card.dart';
import 'package:frontend/ui/task_status_widget.dart';
import 'package:frontend/ui/themed/themed_list_item.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:go_router/go_router.dart';

class CollectionListPage extends StatefulWidget {
  const CollectionListPage({super.key, required this.collectionId});

  final int collectionId;

  @override
  State<CollectionListPage> createState() => _CollectionListPageState();
}

class _CollectionListPageState extends State<CollectionListPage> {
  @override
  void initState() {
    super.initState();
    context.read<CollectionCubit>().fetchCollections();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionCubit, CollectionState>(
      builder: (context, state) {
        if (state is CollectionLoading || state is CollectionInitial) {
          return CupertinoPageScaffold(
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        if (state is CollectionError) {
          return CupertinoPageScaffold(
            child: Center(
              child: DangerCard(
                onTap: () => context.read<CollectionCubit>().fetchCollections(),
                child: ThemedText(
                  state.message,
                  color: TextColor.inverse,
                ),
              ),
            ),
          );
        }

        if (state is CollectionLoaded) {
          if (!state.collections.any((e) => e.id == widget.collectionId)) {
            return CupertinoPageScaffold(
              child: Center(
                child: DangerCard(
                  onTap: () =>
                      context.read<CollectionCubit>().fetchCollections(),
                  child: ThemedText(
                    "Invalid Collection",
                    color: TextColor.inverse,
                  ),
                ),
              ),
            );
          }

          final collection = state.collections
              .firstWhere((element) => element.id == widget.collectionId);
          return CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: Text('Models in ${collection.name}'),
                ),
                CupertinoSliverRefreshControl(
                  onRefresh: () =>
                      context.read<CollectionCubit>().fetchCollections(),
                ),
                if (collection.tasks == null ||
                    (collection.tasks ?? []).isEmpty)
                  const SliverToBoxAdapter(
                      child: Center(
                          child: ThemedText(
                    "No models added",
                    color: TextColor.muted,
                  )))
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.md),
                    sliver: SliverList.builder(
                      itemCount: collection.tasks!.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(bottom: AppPadding.sm),
                        child: ThemedListItem(
                          trailing: TaskStatusWidget(
                              status: collection.tasks![index].status),
                          onTap: () => context.push(
                            '/authed/home/task/${collection.tasks![index].id}',
                          ),
                          title: ThemedText(collection.tasks![index].fTitle,
                              style: TextType.title, size: 16),
                          subtitle: ThemedText(
                            collection.tasks![index].fDescription,
                            style: TextType.small,
                            color: TextColor.secondary,
                          ),
                          dismissableKey: '${collection.tasks![index].id}',
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        }

        return SizedBox();
      },
    );
  }
}
