import 'package:flutter/cupertino.dart';
import 'package:frontend/ui/themed/themed_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';

class StatisticCard extends StatelessWidget {
  const StatisticCard({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon,
  });

  final String title;
  final String subtitle;

  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ThemedCard(
        child: Column(
          children: [
            ThemedText(
              title,
              weight: FontWeight.w600,
            ),
            ThemedText(
              subtitle,
              weight: FontWeight.w700,
              size: 24,
            ),
          ],
        ),
      ),
    );
  }
}
