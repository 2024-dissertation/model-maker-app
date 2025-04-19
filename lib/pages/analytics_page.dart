import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/module/analytics/cubit/analytics_cubit.dart';
import 'package:frontend/ui/statistic_card.dart';
import 'package:frontend/ui/themed/themed_line_chart.dart';
import 'package:frontend/ui/themed/themed_pie_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalyticsCubit, AnalyticsState>(
      builder: (context, state) => CupertinoPageScaffold(
        child: CustomScrollView(
          slivers: [
            CupertinoSliverNavigationBar(
              largeTitle: const Text('Analytics'),
            ),
            CupertinoSliverRefreshControl(),
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: AppPadding.md),
              sliver: SliverList.list(
                children: [
                  ThemedLineChart(title: 'Models by Day', colors: [
                    CupertinoColors.systemBlue,
                    CupertinoColors.systemRed,
                  ], labels: [
                    'Mon',
                    'Tue',
                    'Wed',
                    'Thu',
                    'Fri',
                    'Sat',
                  ], data: [
                    [
                      Random().nextInt(20).toDouble(),
                      Random().nextInt(20).toDouble(),
                      Random().nextInt(20).toDouble(),
                      Random().nextInt(20).toDouble(),
                      Random().nextInt(20).toDouble(),
                      Random().nextInt(20).toDouble(),
                    ],
                    [
                      Random().nextInt(20).toDouble(),
                      Random().nextInt(20).toDouble(),
                      Random().nextInt(20).toDouble(),
                      Random().nextInt(20).toDouble(),
                      Random().nextInt(20).toDouble(),
                      Random().nextInt(20).toDouble(),
                    ]
                  ]),
                  SizedBox(height: AppPadding.md),
                  Row(
                    spacing: AppPadding.md,
                    children: [
                      StatisticCard(
                        title: 'Total Models',
                        subtitle: Random().nextInt(100).toString(),
                      ),
                      StatisticCard(
                        title: 'Total Collections',
                        subtitle: Random().nextInt(100).toString(),
                      ),
                    ],
                  ),
                  SizedBox(height: AppPadding.md),
                  ThemedPieChart(title: 'Models by Collection', labels: [
                    'Cars',
                    'Trains',
                    'Planes'
                  ], data: [
                    Random().nextInt(20).toDouble(),
                    Random().nextInt(20).toDouble(),
                    Random().nextInt(20).toDouble(),
                  ], colors: [
                    CupertinoColors.systemBlue,
                    CupertinoColors.systemRed,
                    CupertinoColors.systemGreen,
                  ]),
                  SizedBox(height: 150),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
