import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/main/main.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:go_router/go_router.dart';

class ViewTaskImages extends StatelessWidget {
  ViewTaskImages({super.key, required this.taskId});

  final int taskId;

  final TaskRepository _taskRepository = getIt();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: ThemedText('All Images'),
      ),
      child: Center(
        child: FutureBuilder(
          future: _taskRepository.getTaskById(taskId),
          builder: (context, data) {
            if (data.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (data.hasError) {
              logger.d("${data.error}, ${data.stackTrace}");
              return Center(
                child: ThemedText(data.error.toString()),
              );
            }
            if (data.hasData) {
              if (data.data!.images == null || data.data!.images!.isEmpty) {
                return const ThemedText("No images");
              }

              final urls = data.data!.imageUrls;
              logger.d(urls);

              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                ),
                itemBuilder: (context, index) => Center(
                  child: CupertinoContextMenu(
                    actions: <Widget>[
                      CupertinoContextMenuAction(
                        onPressed: () {
                          context.pop();
                          Clipboard.setData(
                            ClipboardData(
                              text: urls[index].toString(),
                            ),
                          );
                        },
                        isDefaultAction: true,
                        trailingIcon: CupertinoIcons.doc_on_clipboard_fill,
                        child: const ThemedText('Copy'),
                      ),
                    ],
                    child: Image.network(
                      urls[index].toString(),
                      loadingBuilder: (context, child, loadingProgress) =>
                          loadingProgress == null
                              ? child
                              : const Center(
                                  child: CupertinoActivityIndicator(),
                                ),
                    ),
                  ),
                ),
                itemCount: urls.length,
              );
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}
