import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
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
        _showToast("Camera not mounted", isError: true);
        return;
      }
      setState(() {
        controller = _controller;
      });
    }).catchError((Object e) {
      logger.e(e);
      _showToast("Camera error", isError: true);
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            showSingleActionAlertDialog(context,
                message: "Camera access denied");
            break;
          case 'CameraAccessDeniedWithoutPrompt':
            showSingleActionAlertDialog(context,
                message:
                    "Camera access denied permanently, go to settings to enable camera access");
            break;
          case 'CameraAccessRestricted':
            showSingleActionAlertDialog(context,
                message:
                    "Camera access restricted, go to settings to enable camera access");
          case 'AudioAccessDenied':
          case 'AudioAccessDeniedWithoutPrompt':
          case 'AudioAccessRestricted':
            // Audio errors can be ignored since we don't use audio
            break;
          default:
            break;
        }
      }
    });
  }

  void _showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      backgroundColor:
          isError ? CupertinoColors.systemRed : CupertinoColors.activeGreen,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> capturePhoto() async {
    if (controller != null && controller?.value.isInitialized == true) {
      final photoFile = await controller!.takePicture();
      context.read<ScannerCubit>().addPath(photoFile.path);
      _showToast("Photo captured");
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
          _showToast("Something went wrong", isError: true);
        }
      },
      child: CupertinoPageScaffold(
        backgroundColor: CupertinoColors.systemBackground,
        navigationBar: CupertinoNavigationBar(
          backgroundColor: CupertinoColors.systemBackground.withOpacity(0.8),
          leading: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: () {
              context.read<ScannerCubit>().clear();
            },
            child: const Text("Clear"),
          ),
          trailing: CupertinoButton(
            padding: EdgeInsets.zero,
            onPressed: uploading
                ? null
                : () async {
                    setState(() {
                      uploading = true;
                    });

                    _showToast("Starting upload");

                    if (await context.read<ScannerCubit>().createTask()) {
                      if (context.read<ScannerCubit>().state.paths.isEmpty) {
                        showSingleActionAlertDialog(context,
                            message: "No images to upload");
                        return;
                      }
                      await context.read<ScannerCubit>().uploadImages();
                      context.read<ScannerCubit>().clear();
                      _showToast("Task created successfully");
                    }

                    setState(() {
                      uploading = false;
                    });
                  },
            child: uploading
                ? const CupertinoActivityIndicator()
                : const Text("Done",
                    style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          middle: const Text('Create Task',
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: _visible ? 1.0 : 0.0,
                  child: Container(
                    margin: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: CupertinoColors.black.withOpacity(0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          if (controller != null &&
                              controller?.value.isInitialized == true)
                            CameraPreview(controller!)
                          else
                            Container(
                              color: CupertinoColors.black,
                              child: const Center(
                                child: ThemedText(
                                  "No cameras found",
                                ),
                              ),
                            ),
                          if (controller != null &&
                              controller?.value.isInitialized == true)
                            Positioned(
                              top: 16,
                              right: 16,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: CupertinoColors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color:
                                        CupertinoColors.white.withOpacity(0.2),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      controller!.description.lensDirection ==
                                              CameraLensDirection.front
                                          ? CupertinoIcons.person_fill
                                          : CupertinoIcons.camera_fill,
                                      color: CupertinoColors.white,
                                      size: 16,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      controller!.description.lensDirection ==
                                              CameraLensDirection.front
                                          ? 'Front Camera'
                                          : 'Back Camera',
                                      style: const TextStyle(
                                        color: CupertinoColors.white,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          Positioned(
                            bottom: 24,
                            left: 24,
                            right: 24,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 16,
                              ),
                              decoration: BoxDecoration(
                                color: CupertinoColors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(32),
                                border: Border.all(
                                  color: CupertinoColors.white.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  CameraSnap(
                                    capturePhoto: capturePhoto,
                                  ),
                                  const SizedBox(width: 16),
                                  if (kDebugMode) ...[
                                    ImageSelectButton(
                                      onFilesSelected: (files) {
                                        context.read<ScannerCubit>().addPaths(
                                            files
                                                .map((file) => file.path)
                                                .toList());
                                        _showToast("Images added");
                                      },
                                    ),
                                    const SizedBox(width: 16),
                                  ],
                                  ImageExtraButton(
                                    onFilesSelected: (files) {
                                      context.read<ScannerCubit>().addPaths(
                                          files
                                              .map((file) => file.path)
                                              .toList());
                                      _showToast("Extra images added");
                                    },
                                  ),
                                  const SizedBox(width: 16),
                                  _CameraRotateButton(
                                    onTap: () async {
                                      if (widget.cameras.length > 1) {
                                        camera = (camera + 1) %
                                            widget.cameras.length;
                                        init(camera);
                                        logger.d("Camera changed to $camera");
                                        _showToast("Camera switched");
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  child: BlocBuilder<ScannerCubit, ScannerState>(
                    builder: (context, state) {
                      if (state.paths.isEmpty) {
                        return Center(
                          child: Text(
                            'No images captured yet',
                            style: TextStyle(
                              color: CupertinoColors.label.resolveFrom(context),
                              fontSize: 16,
                            ),
                          ),
                        );
                      }

                      return GridView.builder(
                        scrollDirection: Axis.vertical,
                        padding: EdgeInsets.zero,
                        itemCount: state.paths.length,
                        itemBuilder: (context, index) => ImagePreview(
                          index: index,
                          path: state.paths[index],
                          onDelete: (index) =>
                              context.read<ScannerCubit>().removePath(index),
                        ),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          mainAxisSpacing: 8,
                          crossAxisSpacing: 8,
                          childAspectRatio: 1.0,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CameraRotateButton extends StatelessWidget {
  const _CameraRotateButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 48,
        width: 48,
        decoration: BoxDecoration(
          color: CupertinoColors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: CupertinoColors.white.withOpacity(0.2),
            width: 1,
          ),
        ),
        child: const Icon(
          CupertinoIcons.camera_rotate,
          color: CupertinoColors.white,
          size: 24,
        ),
      ),
    );
  }
}
