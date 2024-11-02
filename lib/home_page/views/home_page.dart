import 'package:flutter/cupertino.dart';
import 'package:frontend/scanner_page/page/scanner_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Home Route'),
      ),
      child: Center(
        child: CupertinoButton.filled(
          child: const Text("Enter"),
          onPressed: () {
            Navigator.of(context).pushNamed(ScannerPage.routeName);
          },
        ),
      ),
    );
  }
}
