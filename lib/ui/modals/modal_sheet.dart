import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ModalSheet extends StatelessWidget {
  const ModalSheet({
    super.key,
    required this.child,
    this.height,
    this.backgroundColor,
    this.topRadius = 16,
    this.showHandle = true,
    this.padding = const EdgeInsets.all(8),
  });

  final Widget child;
  final double? height;
  final Color? backgroundColor;
  final double topRadius;
  final bool showHandle;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.9,
        minHeight: 100,
      ),
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ??
            CupertinoTheme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(topRadius),
          topRight: Radius.circular(topRadius),
        ),
        boxShadow: [
          BoxShadow(
            color: CupertinoColors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showHandle) ...[
            const SizedBox(height: 8),
            Container(
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: CupertinoColors.systemGrey4,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 8),
          ],
          Flexible(
            child: Padding(
              padding: padding,
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

Future<T?> showModalSheet<T>({
  required BuildContext context,
  required Widget child,
  double? height,
  Color? backgroundColor,
  double topRadius = 16,
  bool showHandle = true,
  EdgeInsets padding = const EdgeInsets.all(16),
  bool isDismissible = true,
  bool enableDrag = true,
}) {
  return showCupertinoModalPopup<T>(
    context: context,
    barrierDismissible: isDismissible,
    barrierColor: CupertinoColors.black.withOpacity(0.4),
    builder: (context) => GestureDetector(
      onTap: () => isDismissible ? Navigator.of(context).pop() : null,
      child: ModalSheet(
        height: height,
        backgroundColor: backgroundColor,
        topRadius: topRadius,
        showHandle: showHandle,
        padding: padding,
        child: child,
      ),
    ),
  );
}
