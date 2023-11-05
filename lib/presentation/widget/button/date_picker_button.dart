import 'package:flutter/material.dart';

class DateRangePickerButton extends StatelessWidget {
  final Function(DateTime?, DateTime?) onDateRangePicked;

  const DateRangePickerButton({required this.onDateRangePicked});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final picked = await showDateRangePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );

        if (picked != null) {
          onDateRangePicked(picked.start, picked.end);
        }
      },
      child: const Text("Pick Date Range"),
    );
  }
}