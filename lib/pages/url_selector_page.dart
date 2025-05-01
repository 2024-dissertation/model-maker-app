import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/helpers/globals.dart';
import 'package:frontend/ui/primary_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:go_router/go_router.dart';

class UrlSelectorPage extends StatefulWidget {
  const UrlSelectorPage({super.key});

  @override
  State<UrlSelectorPage> createState() => _UrlSelectorPageState();
}

class _UrlSelectorPageState extends State<UrlSelectorPage> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('URL Selector'),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            spacing: 8,
            mainAxisSize: MainAxisSize.min,
            children: [
              PrimaryCard(
                onTap: () {
                  Globals.baseUrl = "https://soupmodelmaker.org/";
                },
                child: const Row(
                  children: [
                    ThemedText('Main Server', color: TextColor.inverse),
                  ],
                ),
              ),
              PrimaryCard(
                onTap: () {
                  Globals.baseUrl =
                      "https://af0c-143-167-38-88.ngrok-free.app/";
                },
                child: const Row(
                  children: [
                    ThemedText('Ngrok', color: TextColor.inverse),
                  ],
                ),
              ),
              PrimaryCard(
                onTap: () async {
                  final TextEditingController controller =
                      TextEditingController();
                  final data = await showCupertinoDialog<String?>(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoAlertDialog(
                        title: const Text('Set Base URL'),
                        content: Column(
                          children: [
                            const Text('Enter the new base URL:'),
                            CupertinoTextField(
                              controller: controller,
                            ),
                          ],
                        ),
                        actions: [
                          CupertinoDialogAction(
                            child: const Text('Cancel'),
                            onPressed: () {
                              context.pop(null);
                            },
                          ),
                          CupertinoDialogAction(
                            child: const Text('OK'),
                            onPressed: () {
                              context.pop(controller.text);
                            },
                          ),
                        ],
                      );
                    },
                  );
                  if (data != null && data.isNotEmpty) {
                    Globals.baseUrl = data;
                    setState(() {});
                  }
                },
                child: const Row(
                  children: [
                    ThemedText('Set Custom', color: TextColor.inverse),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
