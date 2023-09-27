import 'package:flutter/material.dart';

class BillSummary extends StatelessWidget {
  final double total;
  final VoidCallback onContinue;

  const BillSummary({
    Key? key,
    required this.total,
    required this.onContinue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "รวมเป็นเงิน : $total บาท",
            style: Theme.of(context).textTheme.displayLarge,
          ),
          const SizedBox(width: 16,),
          TextButton(
            onPressed: () => onContinue(),
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primary
              ),
              child: Text(
                "ออกบิล",
                style: Theme.of(context).textTheme.displayLarge,
              ),
            ),
          )
        ],
      ),
    );
  }
}
