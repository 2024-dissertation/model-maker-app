import 'package:flutter/cupertino.dart';
import 'package:frontend/ui/themed/themed_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';

class ErrorCard extends StatelessWidget {
  const ErrorCard(this.error, {super.key, this.onRetry});

  final dynamic error;
  final VoidCallback? onRetry;

  @override
  Widget build(BuildContext context) {
    return ThemedCard(
      color: CupertinoColors.systemRed,
      shadowColor: CupertinoColors.systemBrown,
      onTap: () {
        if (onRetry != null) {
          onRetry!();
        }
      },
      child: ThemedText(
        "Something went wrong",
        color: TextColor.white,
      ),
    );
  }
}
