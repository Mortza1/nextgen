import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BarChartSample6 extends StatelessWidget {
  BarChartSample6({super.key});

  final pilateColor = Color(0xff4B504C);
  final cyclingColor = Color(0xff4B504C);
  final quickWorkoutColor = Color(0xff4B504C);
  final betweenSpace = 0.2;

  /// Generates data for the last 7 hours (rounded values)
  List<BarChartGroupData> generateData() {
    DateTime now = DateTime.now();
    return List.generate(8, (index) {
      DateTime time = now.subtract(Duration(hours: 7 - index));
      double pilates = ((2 + index) % 3 + 1).roundToDouble(); // Rounded
      double quickWorkout = ((3 + index) % 4 + 1.5).roundToDouble(); // Rounded
      double cycling = ((2 + index) % 2 + 2).roundToDouble(); // Rounded

      return generateGroupData(index, pilates, quickWorkout, cycling);
    });
  }

  /// Generates a single group bar
  BarChartGroupData generateGroupData(
      int x, double pilates, double quickWorkout, double cycling) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: pilates + betweenSpace + quickWorkout + betweenSpace + cycling,
          color: pilateColor,
          width: 8,
        ),
      ],
    );
  }

  /// Formats hours for X-axis labels
  Widget bottomTitles(double value, TitleMeta meta) {
    DateTime now = DateTime.now();
    DateTime time = now.subtract(Duration(hours: 7 - value.toInt()));
    String formattedTime = DateFormat.H().format(time); // 24-hour format

    return SideTitleWidget(
      meta: meta,
      child: Text(formattedTime, style: TextStyle(fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      interval: 2, // Interval for Y-axis labels
                      // reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 20,
                    ),
                  ),
                ),
                barTouchData: BarTouchData(enabled: false),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true, // Adds interval lines
                  drawVerticalLine: false,
                  horizontalInterval: 2, // Y-axis interval for grid lines
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                    dashArray: [5, 5], // Dashed grid lines
                  ),
                ),
                barGroups: generateData(),
                maxY: 11 + (betweenSpace * 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class BarChartSample7 extends StatelessWidget {
  BarChartSample7({super.key});

  final pilateColor = Color(0xff4B504C);
  final cyclingColor = Color(0xff93DB95);
  // final quickWorkoutColor = Color(0xff4B504C);
  // final betweenSpace = 0.2;

  /// Generates data for the last 7 hours (rounded values)
  List<BarChartGroupData> generateData() {
    DateTime now = DateTime.now();
    return List.generate(8, (index) {
      DateTime time = now.subtract(Duration(hours: 7 - index));
      double pilates = ((2 + index) % 3 + 1).roundToDouble(); // Rounded
      double quickWorkout = ((3 + index) % 4 + 1.5).roundToDouble(); // Rounded
      double cycling = ((2 + index) % 2 + 2).roundToDouble(); // Rounded

      return generateGroupData(index, pilates, quickWorkout, cycling);
    });
  }

  /// Generates a single group bar
  BarChartGroupData generateGroupData(
      int x, double pilates, double quickWorkout, double cycling) {
    return BarChartGroupData(
      x: x,
      groupVertically: true,
      barRods: [
        BarChartRodData(
          fromY: 0,
          toY: pilates + quickWorkout,
          color: pilateColor,
          width: 8,
            borderRadius: BorderRadius.only(topRight: Radius.circular(0), topLeft: Radius.circular(0))
        ),
        BarChartRodData(
          fromY: pilates + quickWorkout,
          toY: pilates + quickWorkout + cycling,
          color: cyclingColor,
          width: 8,
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(0), bottomLeft: Radius.circular(0), topRight: Radius.circular(10), topLeft: Radius.circular(10))
        ),
      ],
    );
  }

  /// Formats hours for X-axis labels
  Widget bottomTitles(double value, TitleMeta meta) {
    DateTime now = DateTime.now();
    DateTime time = now.subtract(Duration(hours: 7 - value.toInt()));
    String formattedTime = DateFormat.H().format(time); // 24-hour format

    return SideTitleWidget(
      meta: meta,
      child: Text(formattedTime, style: TextStyle(fontSize: 12)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceBetween,
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                      interval: 2, // Interval for Y-axis labels
                      // reservedSize: 30,
                      getTitlesWidget: (value, meta) => Text(
                        value.toInt().toString(),
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ),
                  rightTitles: const AxisTitles(),
                  topTitles: const AxisTitles(),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: bottomTitles,
                      reservedSize: 20,
                    ),
                  ),
                ),
                barTouchData: BarTouchData(enabled: false),
                borderData: FlBorderData(show: false),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true, // Adds interval lines
                  drawVerticalLine: false,
                  horizontalInterval: 2, // Y-axis interval for grid lines
                  getDrawingHorizontalLine: (value) => FlLine(
                    color: Colors.grey.withOpacity(0.3),
                    strokeWidth: 1,
                    dashArray: [5, 5], // Dashed grid lines
                  ),
                ),
                barGroups: generateData(),
                maxY: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
