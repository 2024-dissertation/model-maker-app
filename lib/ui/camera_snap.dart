import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
    return Material(
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
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
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            SizedBox(
              height: 48,
              width: 48,
              child: Icon(CupertinoIcons.camera,
                  color: _disabled ? CupertinoColors.systemGrey : null),
            ),
            if (_disabled)
              const Positioned(
                bottom: 12,
                child: CupertinoActivityIndicator(),
              ),
          ],
        ),
      ),
    );
  }
}
