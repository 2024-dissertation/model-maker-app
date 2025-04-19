import 'package:flutter/cupertino.dart';

class NavItem {
  final String title;
  final IconData icon;

  NavItem({
    required this.title,
    required this.icon,
  });
}

final List<NavItem> navItems = [
  NavItem(
    title: 'Home',
    icon: CupertinoIcons.home,
  ),
  NavItem(
    title: 'Analytics',
    icon: CupertinoIcons.chart_bar,
  ),
  NavItem(
    title: 'New',
    icon: CupertinoIcons.add,
  ),
  NavItem(
    title: 'Profile',
    icon: CupertinoIcons.person,
  ),
];
