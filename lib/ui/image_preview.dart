import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:go_router/go_router.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'dart:typed_data';

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
            onPressed: () async {
              context.pop();
              final status = await Permission.photos.request();
              if (status.isGranted) {
                final file = File(widget.path);
                final bytes = await file.readAsBytes();
                final result = await ImageGallerySaver.saveImage(
                    Uint8List.fromList(bytes));
                if (!mounted) return;
                Fluttertoast.showToast(
                  msg: result['isSuccess'] == true
                      ? 'Saved to gallery'
                      : 'Failed to save',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                );
              } else {
                Fluttertoast.showToast(
                  msg: 'Permission denied',
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                );
              }
            },
            trailingIcon: CupertinoIcons.photo_on_rectangle,
            child: const ThemedText('Save to Gallery')),
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
