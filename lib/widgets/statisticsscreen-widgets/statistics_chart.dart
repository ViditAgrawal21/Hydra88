import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:my_app/helpers/helpers.dart';

class StatisticsChart extends StatelessWidget {
  final int intakeAmount;
  final String activeUnit;
  final List<int> data;
  const StatisticsChart(
      {required this.activeUnit,
      required this.data,
      required this.intakeAmount,
      super.key});

  double calculateMaxY(String activeUnit) {
    return activeUnit == "ml"
        ? max(
            3000,
            data.reduce((curr, next) => curr > next ? curr : next).toDouble() +
                data
                        .reduce((curr, next) => curr > next ? curr : next)
                        .toDouble() /
                    2)
        : max(
            100,
            data.reduce((curr, next) => curr > next ? curr : next).toDouble() +
                data
                        .reduce((curr, next) => curr > next ? curr : next)
                        .toDouble() /
                    2);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;

    final List<Color> gradientColors = [
      Theme.of(context).primaryColor,
      const Color.fromARGB(255, 74, 213, 255)
    ];

    return Container(
      padding: const EdgeInsets.only(right: 25, top: 15, left: 10),
      child: LineChart(LineChartData(
          titlesData: FlTitlesData(
              topTitles: AxisTitles(),
              rightTitles: AxisTitles(),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                    reservedSize: activeUnit == "ml" ? 40 : 70,
                    showTitles: true,
                    interval: activeUnit == "ml" ? 1000 : 30,
                    getTitlesWidget: (value, _) {
                      if (activeUnit == "ml") {
                        return Text(
                          '${(value / 1000).toStringAsFixed((value / 1000) % 1 == 0 ? 0 : 1)}L',
                          style: TextStyle(
                              color: isDarkTheme
                                  ? Colors.white70
                                  : const Color.fromRGBO(0, 0, 0, 0.6)),
                        );
                      }
                      return Text(
                        '${value.toInt()}$activeUnit',
                        style: TextStyle(
                            color: isDarkTheme
                                ? Colors.white70
                                : const Color.fromRGBO(0, 0, 0, 0.6)),
                      );
                    }),
              ),
              bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1,
                      reservedSize: 30,
                      getTitlesWidget: (value, _) {
                        DateTime now = DateTime.now();
                        now = now.subtract(Duration(days: 6 - value.toInt()));
                        return Column(
                          children: [
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              "${parseDay(now.weekday)}.",
                              style: TextStyle(
                                  color: isDarkTheme
                                      ? Colors.white70
                                      : const Color.fromRGBO(0, 0, 0, 0.6)),
                            ),
                          ],
                        );
                      })),
              show: true),
          borderData: FlBorderData(
              border: Border.all(
                  width: 1,
                  color: isDarkTheme
                      ? Colors.white24
                      : const Color.fromRGBO(0, 0, 0, 0.2))),
          gridData: FlGridData(
              show: true,
              getDrawingHorizontalLine: (value) {
                return FlLine(
                  color: isDarkTheme
                      ? Colors.white24
                      : const Color.fromRGBO(0, 0, 0, 0.2),
                  strokeWidth: 1,
                );
              },
              getDrawingVerticalLine: (value) {
                return FlLine(
                  color: isDarkTheme
                      ? Colors.white24
                      : const Color.fromRGBO(0, 0, 0, 0.2),
                  strokeWidth: 1,
                );
              }),
          minX: 0,
          maxX: 6,
          minY: 0,
          maxY: calculateMaxY(activeUnit),
          lineBarsData: [
            LineChartBarData(
                dashArray: [7, 5],
                color: isDarkTheme
                    ? Colors.white54
                    : const Color.fromRGBO(0, 0, 0, 0.3),
                spots: [
                  FlSpot(0, intakeAmount.toDouble()),
                  FlSpot(1, intakeAmount.toDouble()),
                  FlSpot(2, intakeAmount.toDouble()),
                  FlSpot(3, intakeAmount.toDouble()),
                  FlSpot(4, intakeAmount.toDouble()),
                  FlSpot(5, intakeAmount.toDouble()),
                  FlSpot(6, intakeAmount.toDouble())
                ],
                dotData: FlDotData(show: false)),
            LineChartBarData(
                spots: data
                    .asMap()
                    .entries
                    .map((e) => FlSpot(e.key.toDouble(), e.value.toDouble()))
                    .toList(),
                isCurved: false,
                belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                        colors: gradientColors
                            .map((e) => e.withOpacity(0.3))
                            .toList())),
                gradient: LinearGradient(colors: gradientColors))
          ])),
    );
  }
}