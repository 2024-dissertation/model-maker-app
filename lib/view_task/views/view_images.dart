import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:frontend/globals.dart';
import 'package:frontend/logger.dart';
import 'package:frontend/main.dart';
import 'package:frontend/model/task.dart';
import 'package:frontend/repositories/my_user_repository.dart';
import 'package:go_router/go_router.dart';

class ViewTaskImages extends StatelessWidget {
  ViewTaskImages({super.key, required this.task});

  final Task task;

  final MyUserRepository _myUserRepository = getIt();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('All Images'),
      ),
      child: Center(
        child: FutureBuilder(
          future: _myUserRepository.getTaskById(task.id),
          builder: (context, data) {
            if (data.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            if (data.hasError) {
              logger.d("${data.error}, ${data.stackTrace}");
              return Center(
                child: Text(data.error.toString()),
              );
            }
            if (data.hasData) {
              if (data.data!.images.isEmpty) {
                return const Text("No images");
              }

              return GridView.count(
                crossAxisCount: 3,
                children: List.generate(data.data!.images.length, (index) {
                  return Center(
                    child: CupertinoContextMenu(
                      actions: <Widget>[
                        CupertinoContextMenuAction(
                          onPressed: () {
                            context.pop();
                            Clipboard.setData(
                              ClipboardData(
                                text: data.data!.images[index].url,
                              ),
                            );
                          },
                          isDefaultAction: true,
                          trailingIcon: CupertinoIcons.doc_on_clipboard_fill,
                          child: const Text('Copy'),
                        ),
                      ],
                      child: Image.network(
                          "${Globals.baseUrl}${data.data!.images[index].url}"),
                    ),
                  );
                }),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
