import 'package:flutter/material.dart';
import '../../base/ui/picker/month_picker.dart';
import '../widget/item/month_summary_list_item.dart';
import '../widget/section/bar_chart_summary.dart';

class AnalyticScreen extends StatefulWidget {
  const AnalyticScreen({super.key});

  @override
  AnalyticScreenState createState() => AnalyticScreenState();
}

class AnalyticScreenState extends State<AnalyticScreen> {
  int? startMonth;
  int? endMonth;
  Map<int, double> filteredTotals = {
    1: 200.0,
    2: 250.0,
    3: 150.0,
    4: 300.0,
  };

  void _onMonthRangePicked(int? start, int? end) {
    setState(() {
      startMonth = start;
      endMonth = end;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('สรุปยอดแยกโรงแรม')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context),
            _buildMonthPicker(),
            _buildSummaryList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(BuildContext context) {
    return Text(
      "Hotel A",
      style: Theme.of(context).textTheme.displayLarge,
    );
  }

  Widget _buildMonthPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: MonthPickerButton(onMonthRangePicked: _onMonthRangePicked),
    );
  }

  Widget _buildSummaryList() {
    return Expanded(
      child: Column(
        children: [
          Expanded(
            child: MonthSummaryListItem(
              totals: {
                DateTime(2022, 1, 1): 150.0,
                DateTime(2022, 2, 1): 200.0,
                DateTime(2022, 3, 1): 250.0,
              },
            ),
          ),
          Expanded(
            child: BarChartSummary(
              totals: const {
                "1": 200.0,
                "2": 150.0,
                "3": 300.0,
              },
            ),
          ),
        ],
      ),
    );
  }
}
