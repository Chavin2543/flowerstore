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
          firstDate: DateTime(DateTime.now().year - 5),
          lastDate: DateTime(DateTime.now().year + 5),
        );

        if (picked != null) {
          onDateRangePicked(picked.start, picked.end);
        }
      },
      child: const Text("เลือกวันที่"),
    );
  }
}