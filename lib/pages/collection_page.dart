import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/helpers/helpers.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/collections/cubit/collection_cubit.dart';
import 'package:frontend/ui/collection_card.dart';
import 'package:frontend/ui/modals/create_collection_modal.dart';
import 'package:frontend/ui/danger_card.dart';
import 'package:frontend/ui/themed/themed_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:go_router/go_router.dart';

class CollectionPage extends StatefulWidget {
  const CollectionPage({super.key});

  @override
  State<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends State<CollectionPage> {
  @override
  void initState() {
    super.initState();
    context.read<CollectionCubit>().fetchCollections();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CollectionCubit, CollectionState>(
      builder: (context, state) {
        logger.d(state);
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
          return CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: const Text('Collections'),
                  trailing: IconButton(
                    iconSize: 20,
                    icon: Icon(CupertinoIcons.add),
                    onPressed: () async {
                      final data =
                          await showCupertinoSheet<Map<String, String>?>(
                              context: context,
                              useNestedNavigation: true,
                              pageBuilder: (BuildContext context) =>
                                  CreateCollectionModal());
                      if (data != null) {
                        logger.d(data);
                        context.read<CollectionCubit>().createCollection(data!);
                      }
                    },
                  ),
                ),
                CupertinoSliverRefreshControl(
                  onRefresh: () =>
                      context.read<CollectionCubit>().fetchCollections(),
                ),
                if (state.collections.isEmpty)
                  const SliverToBoxAdapter(
                      child: Center(
                          child: ThemedText(
                    "No collections created",
                    color: TextColor.muted,
                  )))
                else
                  SliverPadding(
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.md),
                    sliver: SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: AppPadding.md,
                              crossAxisSpacing: AppPadding.md),
                      itemCount: state.collections.length,
                      itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.only(bottom: AppPadding.sm),
                          child: CollectionCard(
                            collection: state.collections[index],
                            onTap: () {
                              context.go(
                                  '/authed/collection/${state.collections[index].id}');
                            },
                            onLongPress: () async {
                              await showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoActionSheet(
                                      title: const Text('Collection'),
                                      actions: [
                                        CupertinoActionSheetAction(
                                          isDefaultAction: true,
                                          onPressed: () {
                                            context.pop();
                                            context.go(
                                                '/authed/collection/${state.collections[index].id}');
                                          },
                                          child: const Text('View'),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () async {
                                            final TextEditingController
                                                controller =
                                                TextEditingController(
                                              text:
                                                  state.collections[index].name,
                                            );
                                            final data =
                                                await showCupertinoDialog<
                                                    bool?>(
                                              context: context,
                                              builder: (context) {
                                                return CupertinoAlertDialog(
                                                  title: Text('Change name'),
                                                  content: CupertinoTextField(
                                                    controller: controller,
                                                  ),
                                                  actions: [
                                                    CupertinoDialogAction(
                                                      onPressed: () {
                                                        context.pop(false);
                                                      },
                                                      child:
                                                          const Text('Cancel'),
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
                                              context
                                                  .read<CollectionCubit>()
                                                  .saveCollection(
                                                    state.collections[index]
                                                        .copyWith(
                                                      name: controller.text,
                                                    ),
                                                  );
                                            }
                                            context.pop();
                                          },
                                          child: const Text('Edit'),
                                        ),
                                        CupertinoActionSheetAction(
                                          onPressed: () {
                                            context.pop();
                                            context
                                                .read<CollectionCubit>()
                                                .deleteCollection(state
                                                    .collections[index].id);
                                          },
                                          child: const Text('Archive'),
                                        ),
                                      ],
                                      cancelButton: CupertinoActionSheetAction(
                                        onPressed: () => context.pop(),
                                        child: const Text('Cancel'),
                                      ),
                                    );
                                  });
                              context.pop();
                            },
                          )),
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
