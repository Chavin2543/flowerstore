import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class BarChartSummary extends StatelessWidget {
  final Map<DateTime, double> totals;
  BarChartSummary({super.key, required this.totals});

  @override
  Widget build(BuildContext context) {
    final List<BarChartGroupData> barGroups = [];
    final List<String> formattedDates = totals.keys.map((dateTime) {
      return DateFormat('yyyy-MM').format(dateTime);
    }).toList();

    int index = 0;
    totals.forEach((dateTime, total) {
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: total,
              color: Theme.of(context).colorScheme.primary,
              width: 40,
              borderRadius: BorderRadius.circular(6),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
          ],
        ),
      );
      index++;
    });

    return Container(
      padding: EdgeInsets.all(24),
      color: Colors.transparent,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            show: true,
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, titleMeta) {
                  final int index = value.toInt();
                  if (index < formattedDates.length) {
                    // Extract the year and month from the formattedDates[index]
                    final String date = formattedDates[index];
                    final List<String> dateParts = date.split('-');
                    if (dateParts.length == 2) {
                      final String formattedThaiDate = formatThaiDate('${dateParts[0]}-${dateParts[1]}');
                      return Text(formattedThaiDate);
                    }
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barTouchData: BarTouchData(
            touchTooltipData: BarTouchTooltipData(),
            touchCallback: (touchEvent, touchResponse) {},
            handleBuiltInTouches: true,
          ),
          barGroups: barGroups,
        ),
      ),
    );
  }

  String formatThaiDate(String inputDate) {
    DateTime dateTime = DateTime.parse(inputDate + '-01');
    final List<String> thaiMonths = ['มค', 'กพ', 'มีค', 'เมษ', 'พค', 'มิย', 'กค', 'สค', 'กย', 'ตค', 'พย', 'ธค'];
    int month = dateTime.month;
    int year = dateTime.year;
    String formattedDate = '${thaiMonths[month - 1]} ${year.toString().substring(2)}';
    return formattedDate;
  }
}
