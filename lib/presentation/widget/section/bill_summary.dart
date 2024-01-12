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
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).colorScheme.secondary),
              borderRadius: BorderRadius.circular(8),
              color: Theme.of(context).colorScheme.primary
            ),
            child: Text(
              "รวมเป็นเงิน : $total บาท",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          const SizedBox(width: 16,),
          Container(
            decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).colorScheme.secondary),
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).colorScheme.primary
            ),
            child: TextButton(
              onPressed: () => onContinue(),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Theme.of(context).colorScheme.primary
                ),
                child: Text(
                  "ออกบิล",
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
