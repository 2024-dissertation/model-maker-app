import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({
    super.key,
    required this.onContinue,
    required this.pageController,
    required this.pageIndex,
  });

  final VoidCallback onContinue;
  final PageController pageController;
  final int pageIndex;

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage>
    with SingleTickerProviderStateMixin {
  double _opacity = 1.0;
  double _yOffset = 0;
  late AnimationController _animationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  int _tapCount = 0;
  bool _isBouncingFromTap = false;

  @override
  void initState() {
    super.initState();
    widget.pageController.addListener(_onPageChanged);

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rotationAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: -0.05, end: 0.05)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 0.05, end: -0.05)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
    ]).animate(_animationController);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 1.05)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.05, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 1,
      ),
    ]).animate(_animationController);

    _animationController.repeat();
  }

  @override
  void dispose() {
    widget.pageController.removeListener(_onPageChanged);
    _animationController.dispose();
    super.dispose();
  }

  void _onPageChanged() {
    setState(() {
      _opacity = 1.0 - (widget.pageController.page! - widget.pageIndex).abs();
      _yOffset = (widget.pageController.page! - widget.pageIndex) * 100;
    });
  }

  void _onLogoTap() async {
    setState(() {
      _tapCount++;
      _isBouncingFromTap = true;
    });

    // Different haptics based on tap count for extra fun
    if (_tapCount % 3 == 0) {
      HapticFeedback.heavyImpact();
    } else if (_tapCount % 2 == 0) {
      HapticFeedback.mediumImpact();
    } else {
      HapticFeedback.lightImpact();
    }

    // Pause the regular animation
    _animationController.stop();

    // Quick bounce animation
    await Future.delayed(const Duration(milliseconds: 50));
    setState(() => _isBouncingFromTap = false);

    // Resume the regular animation
    _animationController.forward();
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                const Spacer(flex: 1),
                AnimatedSlide(
                  duration: const Duration(milliseconds: 300),
                  offset: Offset(0, _yOffset / 100),
                  child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 300),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: _onLogoTap,
                          child: Container(
                            height: 120,
                            width: 120,
                            margin: const EdgeInsets.only(bottom: 40),
                            child: AnimatedBuilder(
                              animation: _animationController,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _isBouncingFromTap
                                      ? 0.8
                                      : _scaleAnimation.value,
                                  child: Transform.rotate(
                                    angle: _rotationAnimation.value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: CupertinoColors.systemGrey6,
                                        borderRadius: BorderRadius.circular(32),
                                        boxShadow: [
                                          BoxShadow(
                                            color: CupertinoColors.black
                                                .withOpacity(0.1),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                          ),
                                        ],
                                      ),
                                      padding: const EdgeInsets.all(24),
                                      child: SvgPicture(
                                        AssetBytesLoader(
                                            'assets/svg/camera-1-48.svg.vec'),
                                        colorFilter: _tapCount >= 10
                                            ? ColorFilter.mode(
                                                const Color.fromARGB(
                                                    103, 255, 45, 83),
                                                BlendMode.srcATop,
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const ThemedText(
                          "Welcome",
                          style: TextType.title,
                        ),
                        const SizedBox(height: 12),
                        ThemedText(
                          "Let's get started!",
                          style: TextType.body,
                          color: TextColor.muted,
                        ),
                      ],
                    ),
                  ),
                ),
                const Spacer(flex: 1),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: widget.onContinue,
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue',
                          style: TextStyle(
                            color: CupertinoColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(width: 8),
                        Icon(
                          CupertinoIcons.arrow_right,
                          color: CupertinoColors.white,
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
