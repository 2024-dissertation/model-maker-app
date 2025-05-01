import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/module/analytics/cubit/analytics_cubit.dart';
import 'package:frontend/ui/statistic_card.dart';
import 'package:frontend/ui/themed/themed_line_chart.dart';
import 'package:frontend/ui/themed/themed_pie_chart.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AnalyticsCubit, AnalyticsState>(
      listener: (context, state) {
        if (state is AnalyticsError) {
          Fluttertoast.showToast(
            msg: "Something went wrong",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            backgroundColor: CupertinoColors.activeGreen,
            textColor: Colors.white,
            fontSize: 16.0,
          );
        }
      },
      builder: (context, state) {
        if (state is AnalyticsLoading) {
          return const Center(
            child: CupertinoActivityIndicator(),
          );
        }

        if (state is AnalyticsLoaded) {
          return CupertinoPageScaffold(
            child: CustomScrollView(
              slivers: [
                CupertinoSliverNavigationBar(
                  largeTitle: const Text('Analytics'),
                ),
                CupertinoSliverRefreshControl(
                  onRefresh: context.read<AnalyticsCubit>().getAnalytics,
                ),
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: AppPadding.md),
                  sliver: SliverList.list(
                    children: [
                      ThemedLineChart(
                        title: 'Models by Day',
                        colors: [
                          CupertinoColors.systemBlue,
                          CupertinoColors.systemRed,
                        ],
                        labels: state.analytics.weekOfTasks
                            .map((e) => e.date)
                            .toList(),
                        data: [
                          state.analytics.weekOfTasks
                              .map((e) => e.count.toDouble())
                              .toList()
                        ],
                      ),
                      SizedBox(height: AppPadding.md),
                      Row(
                        spacing: AppPadding.md,
                        children: [
                          StatisticCard(
                            title: 'Total Models',
                            subtitle: state.analytics.tasksTotal.toString(),
                          ),
                          StatisticCard(
                            title: 'Total Collections',
                            subtitle:
                                state.analytics.collectionTotal.toString(),
                          ),
                        ],
                      ),
                      SizedBox(height: AppPadding.md),
                      ThemedPieChart(
                          title: 'Models by Collection',
                          labels: state.analytics.collections
                              .map((e) => e.name)
                              .toList(),
                          data: state.analytics.collections
                              .map((e) => e.count.toDouble())
                              .toList(),
                          colors: [
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
          );
        }

        return CupertinoPageScaffold(
          child: Center(
            child: Text('Error loading analytics'),
          ),
        );
      },
    );
  }
}
