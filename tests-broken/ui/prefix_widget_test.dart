import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/ui/prefix_widget.dart';

void main() {
  testWidgets('prefix widget golden test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: PrefixWidget(
          icon: CupertinoIcons.person_2_fill,
          title: 'Edit Details',
          color: CupertinoColors.systemOrange,
        ),
      ),
    );
    await expectLater(
        find.byType(PrefixWidget), matchesGoldenFile('PrefixWidget.png'));
  });
}
