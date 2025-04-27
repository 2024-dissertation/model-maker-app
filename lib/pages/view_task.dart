import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/helpers/globals.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/tasks/models/task.dart';
import 'package:frontend/module/tasks/cubit/view_task_cubit.dart';
import 'package:frontend/module/tasks/repository/task_repository.dart';
import 'package:frontend/ui/danger_card.dart';
import 'package:frontend/ui/primary_card.dart';
import 'package:frontend/ui/task_status_widget.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../main/main.dart';

class ViewTask extends StatelessWidget {
  const ViewTask({
    super.key,
    required this.taskId,
  });

  final int taskId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ViewTaskCubit(taskId)..fetchTask(),
      child: _ViewTask(),
    );
  }
}

class _ViewTask extends StatefulWidget {
  const _ViewTask();

  @override
  State<_ViewTask> createState() => __ViewTaskState();
}

class __ViewTaskState extends State<_ViewTask> {
  Flutter3DController controller = Flutter3DController();

  String? chosenTexture;

  final TaskRepository _taskRepository = getIt();

  File? tmpFile;
  bool started = false;

  @override
  void initState() {
    super.initState();

    controller.onModelLoaded.addListener(() {
      debugPrint('model is loaded : ${controller.onModelLoaded.value}');
    });
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  void downloadFile(int id) async {
    if (!started) {
      started = true;
      var tempDir = await getTemporaryDirectory();

      final _dio = Dio();
      Response response = await _dio.get(
        p.join(Globals.baseUrl, "objects", "$id", "model"),
        onReceiveProgress: showDownloadProgress,
      );

      File file = File("${tempDir.path}/$id.glb");
      var raf = file.openSync(mode: FileMode.write);
      await raf.writeString(response.data);
      await raf.close();

      setState(() {
        tmpFile = file;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: SafeArea(
        child: BlocBuilder<ViewTaskCubit, ViewTaskState>(
            builder: (context, state) {
          if (state is ViewTaskError) {
            return Center(child: ThemedText(state.message));
          }

          if (state is ViewTaskLoading) {
            return const CupertinoActivityIndicator();
          }

          if (state is ViewTaskLoaded) {
            // if (!started) {
            //   downloadFile(state.task.id);
            // }
            if (state.task.mesh != null) {
              // if (tmpFile == null) {
              //   return Center(child: CircularProgressIndicator());
              // }
              return Stack(
                children: [
                  Flutter3DViewer(
                    //If you pass 'true' the flutter_3d_controller will add gesture interceptor layer
                    //to prevent gesture recognizers from malfunctioning on iOS and some Android devices.
                    // the default value is true
                    activeGestureInterceptor: true,
                    //If you don't pass progressBarColor, the color of defaultLoadingProgressBar will be grey.
                    //You can set your custom color or use [Colors.transparent] for hiding loadingProgressBar.
                    progressBarColor: Colors.orange,
                    //You can disable viewer touch response by setting 'enableTouch' to 'false'
                    enableTouch: true,
                    //This callBack will return the loading progress value between 0 and 1.0
                    onProgress: (double progressValue) {
                      debugPrint('model loading progress : $progressValue');
                    },
                    //This callBack will call after model loaded successfully and will return model address
                    onLoad: (String modelAddress) {
                      debugPrint('model loaded : $modelAddress');
                    },
                    //this callBack will call when model failed to load and will return failure error
                    onError: (String error) {
                      debugPrint(p.join(Globals.baseUrl, "objects",
                          "${state.task.mesh!.taskID}", "model"));
                      debugPrint('model failed to load : $error');
                      Fluttertoast.showToast(
                        msg: "Something went wrong",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.red,
                        textColor: Colors.white,
                        fontSize: 16.0,
                      );
                    },
                    //You can have full control of 3d model animations, textures and camera
                    controller: controller,
                    src: p.join(Globals.baseUrl, "objects",
                        "${state.task.mesh!.taskID}", "model"),
                    //src: 'assets/sheen_chair.glb', //3D model with different textures
                    // src: 'assets/test_object.glb',
                    // src:
                    //     'https://modelviewer.dev/shared-assets/models/Astronaut.glb', // 3D model from URL
                  ),
                  // ThemedText(p.join(Globals.baseUrl, "objects",
                  //     "${state.task.mesh!.taskID}", "model")),
                  Positioned(
                    bottom: 16,
                    right: 8,
                    child: Column(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        PrimaryCard(
                          onTap: () {
                            context.push(
                                '/authed/home/task/${state.task.id}/images');
                          },
                          child: const Row(
                            children: [
                              ThemedText('Source', color: TextColor.inverse),
                              CupertinoListTileChevron()
                            ],
                          ),
                        ),
                        PrimaryCard(
                          onTap: () {
                            context.push(
                                '/authed/home/task/${state.task.id}/messages');
                          },
                          child: const Row(
                            children: [
                              ThemedText('Chat', color: TextColor.inverse),
                              CupertinoListTileChevron()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
            return CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: ThemedText(state.task.fTitle),
                  trailing: TaskStatusWidget(status: state.task.status),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppPadding.md),
                      child: ThemedText(state.task.fDescription)),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppPadding.md),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: AppPadding.lg),
                    child: Column(
                      spacing: 8,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        PrimaryCard(
                          onTap: () {
                            context.push(
                                '/authed/home/task/${state.task.id}/images');
                          },
                          child: const Row(
                            children: [
                              ThemedText('View images',
                                  color: TextColor.inverse),
                              CupertinoListTileChevron()
                            ],
                          ),
                        ),
                        PrimaryCard(
                          onTap: () {
                            context.push(
                                '/authed/home/task/${state.task.id}/messages');
                          },
                          child: const Row(
                            children: [
                              ThemedText('View Messages',
                                  color: TextColor.inverse),
                              CupertinoListTileChevron()
                            ],
                          ),
                        ),
                        DangerCard(
                          onTap: () async {
                            _taskRepository.startTask(state.task.id);
                            await Future.delayed(
                                const Duration(milliseconds: 500));
                            context.read<ViewTaskCubit>().fetchTask();
                          },
                          child: const Row(
                            children: [
                              ThemedText('Start process',
                                  color: TextColor.inverse),
                              CupertinoListTileChevron()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            );
          }

          return const SizedBox();
        }),
      ),
    );
  }

  Future<String?> showPickerDialog(String title, List<String> inputList,
      [String? chosenItem]) async {
    return await showCupertinoModalPopup<String>(
      context: context,
      builder: (ctx) {
        return SizedBox(
          height: 250,
          child: inputList.isEmpty
              ? Center(
                  child: ThemedText('$title list is empty'),
                )
              : ListView.separated(
                  itemCount: inputList.length,
                  padding: const EdgeInsets.only(top: 16),
                  itemBuilder: (ctx, index) {
                    return InkWell(
                      onTap: () {
                        context.pop(inputList[index]);
                      },
                      child: Container(
                        height: 50,
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ThemedText('${index + 1}'),
                            ThemedText(inputList[index]),
                            Icon(
                              chosenItem == inputList[index]
                                  ? Icons.check_box
                                  : Icons.check_box_outline_blank,
                            )
                          ],
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (ctx, index) {
                    return const Divider(
                      color: CupertinoColors.inactiveGray,
                      thickness: 0.6,
                      indent: 10,
                      endIndent: 10,
                    );
                  },
                ),
        );
      },
    );
  }
}
