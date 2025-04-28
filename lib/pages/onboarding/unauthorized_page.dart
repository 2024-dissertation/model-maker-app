import 'package:flutter/cupertino.dart';
import 'package:frontend/helpers/theme.dart';
import 'package:frontend/pages/onboarding/sign_up_page.dart';
import 'package:frontend/pages/onboarding/welcome_page.dart';
import 'package:frontend/ui/dot_indicator.dart';

class UnauthorizedPage extends StatefulWidget {
  const UnauthorizedPage({super.key});

  @override
  State<UnauthorizedPage> createState() => _UnauthorizedPageState();
}

class _UnauthorizedPageState extends State<UnauthorizedPage> {
  int index = 0;
  final PageController controller = PageController();

  late List<Widget> pages;

  @override
  void initState() {
    super.initState();

    pages = [
      WelcomePage(
        pageController: controller,
        onContinue: () {
          setState(() {
            index = 1;
            controller.animateToPage(1,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          });
        },
        pageIndex: index,
      ),
      SignUpPage(
        onBack: () {
          setState(() {
            index = 1;
            controller.animateToPage(0,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut);
          });
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Stack(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            color: index == 0
                ? CustomCupertinoTheme.of(context).bgColor1
                : CustomCupertinoTheme.of(context).bgColor2,
            child: PageView.builder(
              controller: controller,
              itemBuilder: (context, index) {
                return pages[index];
              },
              itemCount: pages.length,
              onPageChanged: (index) {
                setState(() {
                  this.index = index;
                });
              },
            ),
          ),
          Positioned(
            top: 0,
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(left: 25),
                child: DotIndicator(
                  itemCount: pages.length,
                  currentIndex: index,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
