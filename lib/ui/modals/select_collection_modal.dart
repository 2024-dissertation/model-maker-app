import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/collections/cubit/collection_cubit.dart';
import 'package:frontend/module/collections/models/collection.dart';
import 'package:frontend/ui/collection_card.dart';
import 'package:frontend/ui/danger_card.dart';
import 'package:frontend/ui/themed/themed_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:go_router/go_router.dart';

class SelectCollectionModal extends StatefulWidget {
  const SelectCollectionModal({super.key});

  @override
  State<SelectCollectionModal> createState() => _SelectCollectionModalState();
}

class _SelectCollectionModalState extends State<SelectCollectionModal> {
  @override
  void initState() {
    super.initState();
    context.read<CollectionCubit>().fetchCollections();
    selectedCollection = null;
  }

  Collection? selectedCollection;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar.large(
        largeTitle: Text('Select Collection'),
        trailing: TextButton(
          child: Text("Done"),
          onPressed: () {
            if (selectedCollection != null) {
              context.pop(selectedCollection);
            } else {
              context.pop(null);
            }
          },
        ),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppPadding.md),
          child: BlocBuilder<CollectionCubit, CollectionState>(
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
                      onTap: () =>
                          context.read<CollectionCubit>().fetchCollections(),
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
                      SliverToBoxAdapter(
                        child: SizedBox(height: AppPadding.lg + 4),
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
                          padding:
                              EdgeInsets.symmetric(horizontal: AppPadding.md),
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
                                    outlined: selectedCollection ==
                                        state.collections[index],
                                    onTap: () async {
                                      setState(() {
                                        selectedCollection =
                                            state.collections[index];
                                      });
                                    },
                                    collection: state.collections[index])),
                          ),
                        ),
                    ],
                  ),
                );
              }

              return SizedBox();
            },
          ),
        ),
      ),
    );
  }
}
