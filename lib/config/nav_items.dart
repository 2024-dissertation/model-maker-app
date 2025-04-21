import 'package:flutter/cupertino.dart';
import 'package:remixicon/remixicon.dart';

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
    icon: RemixIcons.home_2_line,
  ),
  NavItem(
    title: 'Analytics',
    icon: RemixIcons.bar_chart_grouped_line,
  ),
  NavItem(
    title: 'New',
    icon: RemixIcons.add_line,
  ),
  NavItem(
    title: 'Collections',
    icon: RemixIcons.layout_2_line,
  ),
  NavItem(
    title: 'Menu',
    icon: RemixIcons.menu_2_line,
  ),
];
