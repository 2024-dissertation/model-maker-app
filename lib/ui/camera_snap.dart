import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class CameraSnap extends StatefulWidget {
  const CameraSnap({super.key, required this.capturePhoto});

  final Future<void> Function() capturePhoto;

  @override
  State<CameraSnap> createState() => _CameraSnapState();
}

class _CameraSnapState extends State<CameraSnap> {
  bool _disabled = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          decoration: const BoxDecoration(
            color: CupertinoColors.white,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          constraints: const BoxConstraints(
            minWidth: 48,
            minHeight: 48,
          ),
          child: GestureDetector(
            child: Icon(CupertinoIcons.camera,
                color: _disabled ? CupertinoColors.systemGrey : null),
            onTap: () {
              if (_disabled) {
                return;
              }

              setState(() {
                _disabled = true;
              });

              HapticFeedback.lightImpact();

              widget.capturePhoto().whenComplete(() {
                setState(() {
                  _disabled = false;
                });
              });
            },
          ),
        ),
        if (_disabled)
          const Positioned(
            bottom: 12,
            child: CupertinoActivityIndicator(),
          ),
      ],
    );
  }
}
