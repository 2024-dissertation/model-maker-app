import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/ui/image_select_button.dart';

void main() {
  testWidgets('image select button golden test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ImageSelectButton(
          onFilesSelected: (e) {},
        ),
      ),
    );
    await expectLater(find.byType(ImageSelectButton),
        matchesGoldenFile('ImageSelectButton.png'));
  });
}
