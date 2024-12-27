import 'package:flutter/cupertino.dart';
import 'package:frontend/config/nav_items.dart';
import 'package:go_router/go_router.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({
    super.key,
    required this.navigationShell,
    required this.children,
  });

  final StatefulNavigationShell navigationShell;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBuilder: (context, index) {
        return children[index];
      },
      tabBar: CupertinoTabBar(
        currentIndex: navigationShell.currentIndex,
        onTap: navigationShell.goBranch,
        items: navItems
            .map((tab) =>
                BottomNavigationBarItem(icon: Icon(tab.icon), label: tab.title))
            .toList(),
      ),
    );
  }
}
