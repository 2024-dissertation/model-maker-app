import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageExtraButton extends StatelessWidget {
  const ImageExtraButton({super.key, required this.onFilesSelected});
  final Function(List<File>) onFilesSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: CupertinoColors.white,
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      constraints: const BoxConstraints(
        minWidth: 48,
        minHeight: 48,
      ),
      child: GestureDetector(
        child: Icon(CupertinoIcons.layers),
        onTap: () async {
          final ImagePicker _picker = ImagePicker();

          final List<XFile> images = await _picker.pickMultiImage();

          onFilesSelected(images.map((image) => File(image.path)).toList());
        },
      ),
    );
  }
}
