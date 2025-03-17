import 'package:flutter/material.dart';

class ThemedCard extends StatelessWidget {
  const ThemedCard({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      child: child,
    );
  }
}
