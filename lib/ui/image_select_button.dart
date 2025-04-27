import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:frontend/helpers/logger.dart';
import 'dart:io';

class ImageSelectButton extends StatelessWidget {
  const ImageSelectButton({super.key, required this.onFilesSelected});
  final Function(List<File>) onFilesSelected;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: () async {
          logger.d("Started copying files");
          final List<File> copiedFiles = [];

          for (int i = 0; i < 83; i++) {
            final filename = "27-$i.png";
            final assetPath = "assets/images/$filename";

            // Load the asset as bytes
            final byteData = await rootBundle.load(assetPath);

            // Get the temp directory
            final tempDir = await getTemporaryDirectory();
            final tempFilePath = '${tempDir.path}/$filename';

            // Write the bytes to the file
            final file = File(tempFilePath);
            await file.writeAsBytes(byteData.buffer.asUint8List());
            copiedFiles.add(file);
          }

          onFilesSelected(copiedFiles);
        },
        child: SizedBox(
          height: 48,
          width: 48,
          child: Icon(CupertinoIcons.ellipsis_vertical),
        ),
      ),
    );
  }
}
