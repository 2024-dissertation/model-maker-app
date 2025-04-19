import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/helpers/theme.dart';
import 'package:frontend/ui/indicator.dart';
import 'package:frontend/ui/themed/themed_card.dart';
import 'package:frontend/ui/themed/themed_text.dart';

class ThemedPieChart extends StatelessWidget {
  const ThemedPieChart(
      {super.key,
      required this.labels,
      required this.data,
      this.colors,
      this.title});

  final List<String> labels;
  final List<double> data;
  final List<Color>? colors;
  final String? title;

  double get total => data.fold(
        0,
        (previousValue, element) => previousValue + element,
      );

  double get dataMax => data.fold(
        0,
        (previousValue, element) => max(previousValue, element),
      );

  @override
  Widget build(BuildContext context) {
    PieChartData pieChartData() => PieChartData(
          sections: data.asMap().entries.map((entry) {
            final index = entry.key;
            final value = entry.value;
            return PieChartSectionData(
              color: colors?[index] ?? Colors.blue,
              value: value,
              title: '${(value / total * 100).toStringAsFixed(1)}%',
              titleStyle: CustomCupertinoTheme.of(context).body.copyWith(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
              radius: 100,
            );
          }).toList(),
        );

    return ThemedCard(
      child: Column(
        spacing: AppPadding.lg,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          if (title != null)
            ThemedText(
              title!,
              weight: FontWeight.w600,
              size: 18,
            ),
          AspectRatio(
            aspectRatio: 1.23,
            child: Stack(
              children: <Widget>[
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16, left: 6),
                        child: PieChart(
                          pieChartData(),
                          duration: const Duration(milliseconds: 250),
                        ),
                      ),
                    ),
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: labels
                            .asMap()
                            .entries
                            .map(
                              (e) => Indicator(
                                color: colors?[e.key] ?? Colors.blue,
                                text: e.value,
                                isSquare: true,
                              ),
                            )
                            .toList()),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
