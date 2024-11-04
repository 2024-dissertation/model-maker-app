import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/helpers.dart';
import 'package:frontend/scanner_page/cubit/scanner_cubit.dart';
import 'package:frontend/scanner_page/widgets/camera_snap.dart';
import 'package:frontend/scanner_page/widgets/image_preview.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, required this.cameras});
  static const String routeName = '/scanner';

  final List<CameraDescription> cameras;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
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
    if (widget.cameras.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pop();

        showSingleActionAlertDialog(context, message: "No cameras found");
      });
      return;
    }

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
      navigationBar: const CupertinoNavigationBar(
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
            )
          : Center(child: Text("No cameras found")),
    );
  }
}
