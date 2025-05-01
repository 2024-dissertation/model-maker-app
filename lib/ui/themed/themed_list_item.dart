import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/helpers/theme.dart';

class ThemedListItem extends StatelessWidget {
  const ThemedListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    required this.onTap,
    this.bottom,
    this.onLongTap,
    this.onDismissed,
    this.onConfirmDismiss,
    required this.dismissableKey,
  });

  final String dismissableKey;
  final Widget title;
  final Widget? subtitle;
  final Widget? trailing;
  final Widget? bottom;
  final VoidCallback onTap;
  final VoidCallback? onLongTap;
  final VoidCallback? onDismissed;
  final Future<bool> Function()? onConfirmDismiss;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CustomCupertinoTheme.of(context).card,
      borderRadius: BorderRadius.all(Radius.circular(AppPadding.sm)),
      child: InkWell(
        borderRadius: BorderRadius.all(Radius.circular(AppPadding.sm)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(AppPadding.sm)),
            border: Border(
              bottom: BorderSide(
                color: CustomCupertinoTheme.of(context).cardShadow,
                width: 4.0,
              ),
            ),
          ),
          child: Dismissible(
            direction: onDismissed == null
                ? DismissDirection.none
                : DismissDirection.endToStart,
            background: Container(
              color: CupertinoColors.systemRed,
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: 16),
              child: const Icon(
                CupertinoIcons.delete,
                color: CupertinoColors.white,
              ),
            ),
            onDismissed: (direction) => onDismissed?.call(),
            confirmDismiss: (_) async => await onConfirmDismiss?.call(),
            key: Key(dismissableKey),
            child: Column(
              children: [
                ListTile(
                  title: title,
                  subtitle: subtitle,
                  trailing: trailing,
                ),
                if (bottom != null)
                  Padding(
                    padding: const EdgeInsets.only(
                      left: AppPadding.sm,
                      right: AppPadding.sm,
                      bottom: AppPadding.sm,
                    ),
                    child: bottom,
                  ),
              ],
            ),
          ),
        ),
        onTap: () => onTap(),
        onLongPress: () => onLongTap?.call(),
      ),
    );
  }
}
