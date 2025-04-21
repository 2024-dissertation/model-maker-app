import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

  @override
  void initState() {
    super.initState();
    init();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _visible = true;
        });
      }
    });
  }

  Future<void> init() async {
    controller = CameraController(widget.cameras[0], ResolutionPreset.max);
    controller!.initialize().then((_) {
      if (!mounted) {
        print("not mounted");
        return;
      }
      setState(() {});
    }).catchError((Object e) {
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
          showSingleActionAlertDialog(context, message: state.error!);
        }
      },
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          leading: TextButton(
            onPressed: () {
              context.read<ScannerCubit>().clear();
            },
            child: const ThemedText("Clear"),
          ),
          trailing: TextButton(
              onPressed: () async {
                if (await context.read<ScannerCubit>().createTask()) {
                  if (context.read<ScannerCubit>().state.paths.isEmpty) {
                    showSingleActionAlertDialog(context,
                        message: "No images to upload");
                    return;
                  }
                  await context.read<ScannerCubit>().uploadImages();
                }
              },
              child: const ThemedText("Done")),
          middle: const ThemedText('Create Task'),
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
                        ]),
                  ),
                ),
              ]),
            ),
            Expanded(
              child: BlocBuilder<ScannerCubit, ScannerState>(
                builder: (context, state) {
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: state.paths.length,
                    itemBuilder: (context, index) => ImagePreview(
                      index: index,
                      path: state.paths[index],
                      onDelete: (index) =>
                          context.read<ScannerCubit>().removePath(index),
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
