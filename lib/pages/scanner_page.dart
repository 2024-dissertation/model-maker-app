import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/helpers/globals.dart';
import 'package:frontend/helpers/helpers.dart';
import 'package:frontend/helpers/logger.dart';
import 'package:frontend/module/scanner_page/scanner/scanner_cubit.dart';
import 'package:frontend/ui/camera_snap.dart';
import 'package:frontend/ui/image_extra_button.dart';
import 'package:frontend/ui/image_preview.dart';
import 'package:frontend/ui/image_select_button.dart';
import 'package:frontend/ui/themed/themed_text.dart';

class ScannerPage extends StatelessWidget {
  const ScannerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScannerCubit(),
      child: _ScannerPage(
        cameras: Globals.cameras,
      ),
    );
  }
}

class _ScannerPage extends StatefulWidget {
  const _ScannerPage({required this.cameras});

  final List<CameraDescription> cameras;

  @override
  State<_ScannerPage> createState() => __ScannerPageState();
}

class __ScannerPageState extends State<_ScannerPage> {
  CameraController? controller;
  bool _visible = false;

  bool uploading = false;

  @override
  void initState() {
    super.initState();
    init(camera);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  Future<void> init(int camera) async {
    final _controller = CameraController(
      widget.cameras[camera],
      ResolutionPreset.max,
      enableAudio: false,
    );
    _controller.initialize().then((_) {
      if (!mounted) {
        print("not mounted");
        Fluttertoast.showToast(
          msg: "Camera not mounted",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP,
          backgroundColor: CupertinoColors.systemRed,
          textColor: Colors.white,
          fontSize: 16.0,
        );
        return;
      }
      setState(() {
        controller = _controller;
      });
    }).catchError((Object e) {
      logger.e(e);
      Fluttertoast.showToast(
        msg: "Camera error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        backgroundColor: CupertinoColors.systemRed,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            showSingleActionAlertDialog(context,
                message: "Camera access denied");
            break;
          case 'CameraAccessDeniedWithoutPrompt':
            showSingleActionAlertDialog(context,
                message:
                    "Camera access denied perminantly, go to settings to enable camera access");
            break;
          case 'CameraAccessRestricted':
            showSingleActionAlertDialog(context,
                message:
                    "Camera access restricted, go to settings to enable camera access");
          case 'AudioAccessDenied':
            showSingleActionAlertDialog(context,
                message: "Audio access denied");
            break;
          case 'AudioAccessDeniedWithoutPrompt':
            showSingleActionAlertDialog(context,
                message:
                    "Audio access denied perminantly, go to settings to enable audio access");
            break;
          case 'AudioAccessRestricted':
            showSingleActionAlertDialog(context,
                message:
                    "Audio access restricted, go to settings to enable audio access");
          default:
            break;
        }
      }
    });
  }

  Future<void> capturePhoto() async {
    if (controller != null && controller?.value.isInitialized == true) {
      final photoFile = await controller!.takePicture();
      context.read<ScannerCubit>().addPath(photoFile.path);
    }
  }

  int camera = 0;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ScannerCubit, ScannerState>(
      listener: (context, state) {
        if (state.error != null) {
          Fluttertoast.showToast(
            msg: "Something went wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: CupertinoColors.systemRed,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: TextButton(
            onPressed: () {
              context.read<ScannerCubit>().clear();
            },
            child: const Text("Clear"),
          ),
          trailing: TextButton(
              onPressed: () async {
                if (uploading) return;

                setState(() {
                  uploading = true;
                });

                Fluttertoast.showToast(
                  msg: "Starting upload",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  backgroundColor: CupertinoColors.activeGreen,
                  textColor: Colors.white,
                  fontSize: 16.0,
                );
                if (await context.read<ScannerCubit>().createTask()) {
                  if (context.read<ScannerCubit>().state.paths.isEmpty) {
                    showSingleActionAlertDialog(context,
                        message: "No images to upload");
                    return;
                  }
                  await context.read<ScannerCubit>().uploadImages();
                  context.read<ScannerCubit>().clear();
                  Fluttertoast.showToast(
                    msg: "Task created successfully",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.TOP,
                    backgroundColor: CupertinoColors.activeGreen,
                    textColor: Colors.white,
                    fontSize: 16.0,
                  );
                }

                setState(() {
                  uploading = false;
                });
              },
              child: const Text("Done")),
          middle: const Text('Create Task'),
        ),
        child: Column(
          children: [
            AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: _visible ? 1.0 : 0.0,
              child: Stack(children: [
                if (controller != null &&
                    controller?.value.isInitialized == true)
                  CameraPreview(controller!)
                else
                  Center(
                    child: Container(
                        color: CupertinoColors.black,
                        width: double.infinity,
                        height: 500,
                        child: ThemedText("No cameras found")),
                  ),
                Positioned(
                  bottom: 16,
                  left: 16,
                  right: 16,
                  child: Center(
                    child: Row(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 8,
                        children: [
                          CameraSnap(capturePhoto: capturePhoto),
                          ImageSelectButton(
                            onFilesSelected: (files) {
                              logger.d("Started");
                              context.read<ScannerCubit>().addPaths(
                                  files.map((file) => file.path).toList());
                            },
                          ),
                          ImageExtraButton(
                            onFilesSelected: (files) {
                              context.read<ScannerCubit>().addPaths(
                                  files.map((file) => file.path).toList());
                            },
                          ),
                          Material(
                            borderRadius: BorderRadius.circular(24),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(24),
                              child: SizedBox(
                                height: 48,
                                width: 48,
                                child: Icon(CupertinoIcons.camera_rotate),
                              ),
                              onTap: () async {
                                if (widget.cameras.length > 1) {
                                  camera = (camera + 1) % widget.cameras.length;
                                  init(camera);
                                  logger.d("Camera changed to $camera");
                                  Fluttertoast.showToast(
                                    msg: "Camera changed to $camera",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.TOP,
                                    backgroundColor:
                                        CupertinoColors.activeGreen,
                                    textColor: Colors.white,
                                    fontSize: 16.0,
                                  );
                                }
                              },
                            ),
                          ),
                        ]),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: BlocBuilder<ScannerCubit, ScannerState>(
                builder: (context, state) {
                  return GridView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: state.paths.length,
                    itemBuilder: (context, index) => ImagePreview(
                      index: index,
                      path: state.paths[index],
                      onDelete: (index) =>
                          context.read<ScannerCubit>().removePath(index),
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                      childAspectRatio: 1.0,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
