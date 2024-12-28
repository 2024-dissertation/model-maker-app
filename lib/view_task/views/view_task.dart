import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/globals.dart';
import 'package:frontend/logger.dart';
import 'package:frontend/model/task.dart';
import 'package:frontend/view_task/cubit/view_task_cubit.dart';
import 'package:frontend/view_task/widgets/mage_carousel.dart';
import 'package:go_router/go_router.dart';

class ViewTask extends StatelessWidget {
  const ViewTask({
    super.key,
    this.task,
    this.taskId,
  });

  final Task? task;
  final int? taskId;

  @override
  Widget build(BuildContext context) {
    if (task == null && taskId == null) {
      throw Exception("Task or taskId must be provided");
    }

    if (task != null) {
      return BlocProvider(
        create: (_) => ViewTaskCubit.preLoaded(task!),
        child: _ViewTask(),
      );
    }

    return BlocProvider(
      create: (_) => ViewTaskCubit(taskId!),
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

  @override
  void initState() {
    super.initState();

    controller.onModelLoaded.addListener(() {
      debugPrint('model is loaded : ${controller.onModelLoaded.value}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Task'),
      ),
      child: SafeArea(
        child: Center(
          child: BlocBuilder<ViewTaskCubit, ViewTaskState>(
              builder: (context, state) {
            if (state is ViewTaskError) {
              return Text(state.message);
            }

            if (state is ViewTaskLoading) {
              return const CupertinoActivityIndicator();
            }

            if (state is ViewTaskLoaded) {
              if (state.task.mesh != null) {
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
                          debugPrint('model failed to load : $error');
                        },
                        //You can have full control of 3d model animations, textures and camera
                        controller: controller,
                        src: "${Globals.baseUrl}${state.task.mesh!.url}"
                        //src: 'assets/sheen_chair.glb', //3D model with different textures
                        // src: 'assets/test_object.glb',
                        // src:
                        //     'https://modelviewer.dev/shared-assets/models/Astronaut.glb', // 3D model from URL
                        ),
                    Text("${Globals.baseUrl}${state.task.mesh!.url}"),
                    Positioned(
                      bottom: 16,
                      right: 8,
                      child: CupertinoButton.filled(
                        child: const Icon(CupertinoIcons.add),
                        onPressed: () async {
                          List<String> availableTextures =
                              await controller.getAvailableTextures();
                          logger.d(
                              'Textures : $availableTextures --- Length : ${availableTextures.length}');
                          debugPrint(
                              'Textures : $availableTextures --- Length : ${availableTextures.length}');
                          chosenTexture = await showPickerDialog(
                              'Textures', availableTextures, chosenTexture);
                          controller.setTexture(
                              textureName: chosenTexture ?? '');
                        },
                      ),
                    ),
                  ],
                );
              }
              return Column(
                children: [
                  Text(state.task.title),
                  Text(state.task.description),
                  CarouselDemo(task: state.task),
                ],
              );
            }

            return const SizedBox();
          }),
        ),
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
                  child: Text('$title list is empty'),
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
                            Text('${index + 1}'),
                            Text(inputList[index]),
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
