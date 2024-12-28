import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:frontend/globals.dart';
import 'package:frontend/model/task.dart';
import 'package:go_router/go_router.dart';

class ViewTaskImages extends StatelessWidget {
  const ViewTaskImages({super.key, required this.task});

  final Task task;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('All Images'),
      ),
      child: Center(
        child: GridView.count(
          crossAxisCount: 3,
          children: List.generate(task.images.length, (index) {
            return Center(
              child: CupertinoContextMenu(
                actions: <Widget>[
                  CupertinoContextMenuAction(
                    onPressed: () {
                      context.pop();
                      Clipboard.setData(
                        ClipboardData(
                          text: task.images[index].url,
                        ),
                      );
                    },
                    isDefaultAction: true,
                    trailingIcon: CupertinoIcons.doc_on_clipboard_fill,
                    child: const Text('Copy'),
                  ),
                ],
                child: Image.network(
                    "${Globals.baseUrl}${task.images[index].url}"),
              ),
            );
          }),
        ),
      ),
    );
  }
}
