import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/module/collections/cubit/collection_cubit.dart';
import 'package:frontend/module/collections/models/collection.dart';
import 'package:frontend/ui/themed/themed_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:go_router/go_router.dart';

class CollectionCard extends StatelessWidget {
  const CollectionCard({
    super.key,
    required this.collection,
    this.onTap,
    this.outlined = false,
  });

  final Collection collection;
  final bool outlined;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ThemedCard(
          outlined: outlined,
          onTap: () async {
            if (onTap != null) {
              onTap!();
              return;
            }
          },
          child: Center(
            child: ThemedText(
              collection.name,
              weight: FontWeight.w600,
            ),
          ),
        ),
        Positioned(
          bottom: 15,
          right: 15,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: CupertinoColors.systemGrey5,
              borderRadius: BorderRadius.circular(16),
            ),
            child: ThemedText(
              "${collection.tasks?.length}",
              weight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
