import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MonthSummaryListItem extends StatelessWidget {
  final Map<DateTime, double> totals;
  final Map<DateTime, double> discountedTotals;
  final Map<DateTime, double> discounts;

  const MonthSummaryListItem({
    super.key,
    required this.totals,
    required this.discountedTotals,
    required this.discounts,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: totals.length,
      itemBuilder: (context, index) {
        final ValueNotifier<Color> backgroundColor = ValueNotifier(Colors.grey);
        DateTime date = totals.keys.elementAt(index);
        double total = totals[date]!;
        double discountedTotal = discountedTotals[date]!;
        double discount = discounts[date]!;
        String month = DateFormat('MMMM', 'th_TH').format(date);
        int year = date.year + 543;
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: MouseRegion(
              onEnter: (_) {
                backgroundColor.value = Theme.of(context).colorScheme.primary;
              },
              onExit: (_) {
                backgroundColor.value = Colors.white;
              },
              child: GestureDetector(
                onTap: () {},
                child: ValueListenableBuilder(
                  valueListenable: backgroundColor,
                  builder: (context, Color color, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: color,
                      child: ListTile(
                        tileColor: Colors.transparent,
                        title: Text('เดือน: $month, ปี: $year'),
                        subtitle: Text('ยอดรวม: $total บาท ส่วนลด $discount ยอดสุทธิ $discountedTotal'),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
