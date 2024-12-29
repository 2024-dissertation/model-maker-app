import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/globals.dart';
import 'package:frontend/helpers.dart';
import 'package:frontend/scanner_page/cubit/scanner_cubit.dart';
import 'package:frontend/scanner_page/widgets/camera_snap.dart';
import 'package:frontend/scanner_page/widgets/image_preview.dart';
import 'package:go_router/go_router.dart';

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
  const _ScannerPage({super.key, required this.cameras});

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
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: IconButton(
          onPressed: () {
            context.read<ScannerCubit>().clear();
          },
          icon: Icon(CupertinoIcons.refresh_thick),
        ),
        trailing: IconButton(
            onPressed: () {
              context.read<ScannerCubit>().createTask();
            },
            icon: Icon(CupertinoIcons.check_mark)),
        middle: Text('Scanner Page'),
      ),
      child: controller != null && controller?.value.isInitialized == true
          ? Column(
              children: [
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _visible ? 1.0 : 0.0,
                  child: Stack(children: [
                    CameraPreview(controller!),
                    Positioned(
                      bottom: 16,
                      left: 16,
                      right: 16,
                      child: CameraSnap(capturePhoto: capturePhoto),
                    ),
                  ]),
                ),
                Expanded(
                  child: BlocBuilder<ScannerCubit, ScannerState>(
                    builder: (context, state) {
                      if (state is ScannerError) {
                        return Column(
                          children: [
                            Text(state.message),
                            CupertinoButton.filled(
                                onPressed: () {
                                  context.read<ScannerCubit>().clear();
                                },
                                child: const Text("Retry"))
                          ],
                        );
                      }
                      if (state is ScannerLoaded) {
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
                      }

                      return SizedBox();
                    },
                  ),
                ),
              ],
            )
          : Center(child: Text("No cameras found")),
    );
  }
}
