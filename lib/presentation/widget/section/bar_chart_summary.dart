import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class BarChartSummary extends StatelessWidget {
  final Map<DateTime, double> totals;
  final Map<DateTime, double> discounts;
  final Map<DateTime, double> discountedTotals;

  const BarChartSummary({
    super.key,
    required this.totals,
    required this.discounts,
    required this.discountedTotals,
  });

  @override
  Widget build(BuildContext context) {
    final List<BarChartGroupData> barGroups = [];
    final List<String> formattedDates = totals.keys.map((dateTime) {
      return DateFormat('yyyy-MM').format(dateTime);
    }).toList();

    int index = 0;
    totals.forEach((dateTime, total) {
      final double discount = discounts[dateTime] ?? 0.0;
      final double discountedTotal = discountedTotals[dateTime] ?? 0.0;
      barGroups.add(
        BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: discount,
              color: Theme.of(context).colorScheme.secondary,
              width: 40,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
            BarChartRodData(
              toY: total,
              color: Theme.of(context).colorScheme.primary,
              width: 40,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
            BarChartRodData(
              toY: discountedTotal,
              color: Colors.amberAccent,
              width: 40,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(6),
                topRight: Radius.circular(6),
              ),
              borderSide: const BorderSide(color: Colors.black, width: 1),
            ),
          ],
        ),
      );
      index++;
    });

    return Container(
      padding: const EdgeInsets.all(24),
      color: Colors.transparent,
      child: BarChart(
        BarChartData(
          titlesData: FlTitlesData(
            show: true,
            topTitles:
                const AxisTitles(sideTitles: SideTitles(showTitles: false)),
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
                      final String formattedThaiDate =
                          formatThaiDate('${dateParts[0]}-${dateParts[1]}');
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
    final List<String> thaiMonths = [
      'มค',
      'กพ',
      'มีค',
      'เมษ',
      'พค',
      'มิย',
      'กค',
      'สค',
      'กย',
      'ตค',
      'พย',
      'ธค'
    ];
    int month = dateTime.month;
    int year = dateTime.year;
    String formattedDate =
        '${thaiMonths[month - 1]} ${year.toString().substring(2)}';
    return formattedDate;
  }
}
