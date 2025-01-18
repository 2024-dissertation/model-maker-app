import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';

Future<void> showAlertDialog(BuildContext context,
    {String title = "Alert",
    String message = "Proceed with action?",
    String actionText = "Yes",
    Function? onActionPressed,
    String cancelText = "No",
    Function? onCancelPressed,
    bool isDestructiveAction = false}) async {
  await showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          /// This parameter indicates this action is the default,
          /// and turns the action's text to bold text.
          isDefaultAction: true,
          onPressed: () {
            context.pop();
            onCancelPressed?.call();
          },
          child: Text(cancelText),
        ),
        CupertinoDialogAction(
          /// This parameter indicates the action would perform
          /// a destructive action such as deletion, and turns
          /// the action's text color to red.
          isDestructiveAction: isDestructiveAction,
          onPressed: () {
            context.pop();
            onActionPressed?.call();
          },
          child: Text(actionText),
        ),
      ],
    ),
  );
}

Future<void> showSingleActionAlertDialog(BuildContext context,
    {String title = "Alert",
    String message = "Proceed with action?",
    String actionText = "Yes",
    Function? onActionPressed,
    bool isDestructiveAction = false}) async {
  await showCupertinoDialog<void>(
    context: context,
    builder: (BuildContext context) => CupertinoAlertDialog(
      title: Text(title),
      content: Text(message),
      actions: <CupertinoDialogAction>[
        CupertinoDialogAction(
          isDefaultAction: true,
          isDestructiveAction: isDestructiveAction,
          onPressed: () {
            context.pop();
            onActionPressed?.call();
          },
          child: Text(actionText),
        ),
      ],
    ),
  );
}

Future<String> getFileType(File file) async {
  final imageExtensions = ['jpg', 'jpeg', 'png', 'gif'];
  final textExtensions = ['txt', 'md', 'json'];

  final fileExtension = file.path.split('.').last.toLowerCase();

  if (imageExtensions.contains(fileExtension)) {
    return 'image';
  } else if (textExtensions.contains(fileExtension)) {
    return 'text';
  } else {
    return 'other';
  }
}

extension CubitExt<T> on Cubit<T> {
  void safeEmit(T state) {
    if (!isClosed) {
      // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
      emit(state);
    }
  }
}
