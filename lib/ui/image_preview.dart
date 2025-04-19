import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:go_router/go_router.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({
    super.key,
    required this.index,
    required this.path,
    required this.onDelete,
  });
  final int index;
  final String path;

  final Function(int index) onDelete;

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  bool _isVisibile = false;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) {
        return;
      }
      setState(() {
        _isVisibile = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoContextMenu(
      actions: [
        CupertinoContextMenuAction(
          onPressed: () {
            context.pop();
          },
          isDefaultAction: true,
          trailingIcon: CupertinoIcons.doc_on_clipboard_fill,
          child: const ThemedText('Copy'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            context.pop();
          },
          trailingIcon: CupertinoIcons.share,
          child: const ThemedText('Share'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            context.pop();
            widget.onDelete(widget.index);
          },
          isDestructiveAction: true,
          trailingIcon: CupertinoIcons.delete,
          child: const ThemedText('Delete'),
        ),
      ],
      child: AnimatedOpacity(
        opacity: _isVisibile ? 1.0 : 0.0,
        duration: const Duration(seconds: 1),
        child: Stack(
          children: [
            widget.path.contains("assets/")
                ? Image.asset(widget.path)
                : Image.file(File(widget.path)),
            Positioned(
              top: 6,
              left: 6,
              child: Container(
                decoration: const BoxDecoration(
                  color: CupertinoColors.white,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
                child: ThemedText(
                  '${widget.index}',
                  size: 16 * 0.6,
                  style: TextType.title,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
