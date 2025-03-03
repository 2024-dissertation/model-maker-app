import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/pages/settings_page.dart';

void main() {
  testWidgets('settings page golden test', (tester) async {
    await tester.pumpWidget(
      MaterialApp(home: SettingsPage()),
    );
    await expectLater(
        find.byType(SettingsPage), matchesGoldenFile('SettingsPage.png'));
  });
}
