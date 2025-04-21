import 'package:flutter/cupertino.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/ui/danger_card.dart';
import 'package:frontend/ui/primary_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:go_router/go_router.dart';

class CreateCollectionModal extends StatelessWidget {
  CreateCollectionModal({super.key});

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar.large(
        largeTitle: Text('Create Collection'),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppPadding.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                height: 64,
              ),
              CupertinoTextField(
                placeholder: 'Enter collection name',
                controller: _controller,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: CupertinoColors.systemGrey5,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  DangerCard.medium(
                    onTap: () {
                      context.pop(null);
                    },
                    child: const ThemedText(
                      'Cancel',
                      color: TextColor.inverse,
                      weight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 8),
                  PrimaryCard.medium(
                    onTap: () {
                      context.pop({'name': _controller.text});
                    },
                    child: const ThemedText(
                      'Confirm',
                      color: TextColor.inverse,
                      weight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
