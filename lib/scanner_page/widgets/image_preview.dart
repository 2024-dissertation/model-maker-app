import 'dart:io';

import 'package:flutter/cupertino.dart';
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
          child: const Text('Copy'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            context.pop();
          },
          trailingIcon: CupertinoIcons.share,
          child: const Text('Share'),
        ),
        CupertinoContextMenuAction(
          onPressed: () {
            context.pop();
            widget.onDelete(widget.index);
          },
          isDestructiveAction: true,
          trailingIcon: CupertinoIcons.delete,
          child: const Text('Delete'),
        ),
      ],
      child: AnimatedOpacity(
        opacity: _isVisibile ? 1.0 : 0.0,
        duration: const Duration(seconds: 1),
        child: Stack(
          children: [
            Image.file(File(widget.path)),
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
                child: Text(
                  '${widget.index}',
                  style: const TextStyle(
                    color: CupertinoColors.black,
                    fontSize: 16 * 0.6,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
