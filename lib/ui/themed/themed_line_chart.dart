import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/config/constants.dart';
import 'package:frontend/helpers/theme.dart';
import 'package:frontend/ui/themed/themed_card.dart';
import 'package:frontend/ui/themed/themed_icon.dart';
import 'package:frontend/ui/themed/themed_text.dart';
import 'package:remixicon/remixicon.dart';

class _LineChart extends StatelessWidget {
  const _LineChart({required this.labels, required this.data, this.colors});

  final List<String> labels;
  final List<List<double>> data;
  final List<Color>? colors;

  double get dataMax => data.fold(
        0,
        (previousValue, element) => max(
            previousValue,
            element.fold(previousValue,
                (previousValue, element) => max(previousValue, element))),
      );

  @override
  Widget build(BuildContext context) {
    return LineChart(
      lineChartData,
      duration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get lineChartData => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: labels.length.toDouble() - 1,
        maxY: dataMax,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          getTooltipColor: (touchedSpot) =>
              Colors.blueGrey.withValues(alpha: 0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 {
    int index = 0;
    return data.map((e) => getLineBar(index++)).toList();
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) => ThemedText("$value");

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: dataMax == 0 ? 1 : dataMax / 4,
        reservedSize: 40,
      );

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: (double value, TitleMeta meta) =>
            ThemedText(labels[value.round()]),
      );

  FlGridData get gridData => const FlGridData(show: false);

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border(
          bottom: BorderSide(color: coralPink),
          left: const BorderSide(color: Colors.transparent),
          right: const BorderSide(color: Colors.transparent),
          top: const BorderSide(color: Colors.transparent),
        ),
      );

  LineChartBarData getLineBar(int index) {
    int xIndex = 0;
    return LineChartBarData(
      isCurved: true,
      color: colors != null
          ? colors![index]
          : desaturatedPink
              .withAlpha(255 - (index * (255 / data.length)).toInt()),
      barWidth: 8,
      isStrokeCapRound: true,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
      spots: data[index]
          .map(
            (e) => FlSpot(
              (xIndex++).toDouble(),
              e,
            ),
          )
          .toList(),
    );
  }
}

class ThemedLineChart extends StatefulWidget {
  const ThemedLineChart({
    super.key,
    required this.labels,
    required this.data,
    this.colors,
    this.title,
  });

  final String? title;

  final List<String> labels;
  final List<List<double>> data;
  final List<Color>? colors;

  @override
  State<StatefulWidget> createState() => ThemedLineChartState();
}

class ThemedLineChartState extends State<ThemedLineChart> {
  @override
  void initState() {
    super.initState();
  }

  Widget _comparisonLabel() {
    if (widget.data.length < 2) {
      return const SizedBox.shrink();
    }
    final lastWeekTotal = widget.data[0].fold(
      0.0,
      (previousValue, element) => previousValue + element,
    );

    final lastWeekAverage = lastWeekTotal / widget.data[0].length;

    final currentWeekTotal = widget.data[1].fold(
      0.0,
      (previousValue, element) => previousValue + element,
    );

    final currentWeekAverage = currentWeekTotal / widget.data[1].length;
    final comparisonValue = currentWeekAverage - lastWeekAverage;

    return Row(children: [
      ThemedIcon(
          icon: (comparisonValue > 0)
              ? RemixIcons.arrow_up_double_fill
              : comparisonValue < 0
                  ? RemixIcons.arrow_down_double_fill
                  : RemixIcons.equal_fill,
          size: 16,
          color: comparisonValue > 0
              ? CupertinoColors.activeGreen
              : comparisonValue < 0
                  ? CupertinoColors.systemPink
                  : CupertinoColors.systemGrey),
      ThemedText(
        color: comparisonValue > 0
            ? TextColor.success
            : comparisonValue < 0
                ? TextColor.warning
                : TextColor.secondary,
        "${((comparisonValue.abs())).toStringAsFixed(1)} This Week",
        size: 12,
        weight: FontWeight.w600,
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return ThemedCard(
      child: AspectRatio(
        aspectRatio: 1.23,
        child: Stack(
          children: <Widget>[
            Positioned(
              right: 0,
              top: 0,
              child: _comparisonLabel(),
            ),
            Column(
              spacing: AppPadding.lg,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                if (widget.title != null)
                  ThemedText(
                    widget.title!,
                    weight: FontWeight.w600,
                    size: 18,
                  ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16, left: 6),
                    child: _LineChart(
                      labels: widget.labels,
                      data: widget.data,
                      colors: widget.colors,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
