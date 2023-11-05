import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSummary extends StatelessWidget {
  final Map<String, double> totals;
  BarChartSummary({required this.totals});

  @override
  Widget build(BuildContext context) {
    final List<BarChartGroupData> barGroups = [];

    totals.forEach((companyName, total) {
      final index = barGroups.length;
      barGroups.add(
          BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: total,
                color: Theme.of(context).colorScheme.primary,
                width: 40,
                borderRadius: BorderRadius.circular(6),
                borderSide: BorderSide(color: Colors.black, width: 1),
              ),
            ],
          )
      );
    });

    return Container(
      padding: EdgeInsets.all(24),
      color: Colors.transparent,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            show: true,
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, titleMeta) {
                    final int index = value.toInt();
                    return Text(totals.keys.elementAt(index).toString());
                  },
                )
            ),
            leftTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false)
            ),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
              show: false
          ),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(
            ),
            touchCallback: (touchEvent, touchResponse) {},
            handleBuiltInTouches: true,
          ),
          barGroups: barGroups,
        ),
      ),
    );
  }
}
