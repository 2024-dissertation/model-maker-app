import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage(
      {super.key,
      required this.onContinue,
      required this.pageController,
      required this.pageIndex});

  final VoidCallback onContinue;
  final PageController pageController;
  final int pageIndex;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  double _opacity = 1.0;
  double _yOffset = -50;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_onPageChanged);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_onPageChanged);
    super.dispose();
  }

  void _onPageChanged() {
    setState(() {
      _opacity = 1.0 - (widget.pageController.page! - widget.pageIndex).abs();
      _yOffset = -50 + (1 - _opacity) * 100;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: Duration(milliseconds: 300),
      child: Stack(
        children: [
          Positioned(
            bottom: -70 + _yOffset,
            right: -90,
            child: Transform.rotate(
              angle: math.pi / 12.0,
              child: SvgPicture(
                AssetBytesLoader('assets/svg/camera-1-48.svg.vec'),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ThemedText(
                  "Welcome",
                  style: TextType.title,
                ),
                ThemedText(
                  "Let's get started!",
                  style: TextType.subtitle,
                  color: TextColor.secondary,
                ),
              ],
            ),
          ),
          SafeArea(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: CupertinoButton.filled(
                onPressed: () => widget.onContinue(),
                child: ThemedText("Continue"),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
