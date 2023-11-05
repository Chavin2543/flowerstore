import 'package:flowerstore/helper/customer_store.dart';
import 'package:flutter/material.dart';

class InvoiceSummary extends StatelessWidget {
  final Map<String, double> totals;

  InvoiceSummary({required this.totals});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: totals.length,
      itemBuilder: (context, index) {
        final name = totals.keys.elementAt(index);
        final total = totals[name]!;
        final ValueNotifier<Color> backgroundColor = ValueNotifier(Colors.grey);

        return Container(
          margin: EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Theme.of(context).colorScheme.secondary)
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: MouseRegion(
              onEnter: (_) {
                backgroundColor.value = Theme.of(context).colorScheme.secondary;
              },
              onExit: (_) {
                backgroundColor.value = Theme.of(context).colorScheme.primary;
              },
              child: GestureDetector(
                onTap: () {
                },
                child: ValueListenableBuilder(
                  valueListenable: backgroundColor,
                  builder: (context, Color color, child) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      color: color,
                      child: ListTile(
                        tileColor: Colors.transparent,
                        title: Text(name),
                        subtitle: Text('Total: \$$total'),
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
