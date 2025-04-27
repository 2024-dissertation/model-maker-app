import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImageExtraButton extends StatelessWidget {
  const ImageExtraButton({super.key, required this.onFilesSelected});
  final Function(List<File>) onFilesSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () async {
          final ImagePicker _picker = ImagePicker();

          final List<XFile> images = await _picker.pickMultiImage();

          onFilesSelected(images.map((image) => File(image.path)).toList());
        },
        child: SizedBox(
          height: 48,
          width: 48,
          child: Icon(CupertinoIcons.layers),
        ),
      ),
    );
  }
}
