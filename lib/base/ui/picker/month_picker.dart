import 'package:flutter/material.dart';

class MonthPickerButton extends StatefulWidget {
  final Function(int, int, int, int) onMonthYearRangePicked;

  const MonthPickerButton({super.key, required this.onMonthYearRangePicked});

  @override
  State<MonthPickerButton> createState() => _MonthPickerButtonState();
}

class _MonthPickerButtonState extends State<MonthPickerButton> {
  int startMonth = 1;
  int endMonth = DateTime.now().month;
  int startYear = DateTime.now().year;
  int endYear = DateTime.now().year;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        final picked = await showDialog<List<int>>(
          context: context,
          builder: (context) => MonthPickerDialog(
            initialStartYear: startYear,
            initialStartMonth: startMonth,
            initialEndYear: endYear,
            initialEndMonth: endMonth,
          ),
        );
        if (picked != null && picked.length == 4) {
          setState(() {
            startYear = picked[0];
            startMonth = picked[1];
            endYear = picked[2];
            endMonth = picked[3];
          });
          widget.onMonthYearRangePicked(
              startYear, startMonth, endYear, endMonth);
        }
      },
      child: const Text('เลือกช่วงเดือน'),
    );
  }
}

class MonthPickerDialog extends StatefulWidget {
  final int initialStartYear;
  final int initialStartMonth;
  final int initialEndYear;
  final int initialEndMonth;

  const MonthPickerDialog({
    Key? key,
    required this.initialStartYear,
    required this.initialStartMonth,
    required this.initialEndYear,
    required this.initialEndMonth,
  }) : super(key: key);

  @override
  _MonthPickerDialogState createState() => _MonthPickerDialogState();
}

class _MonthPickerDialogState extends State<MonthPickerDialog> {
  late int startYear;
  late int startMonth;
  late int endYear;
  late int endMonth;
  final thaiMonths = [
    'มกราคม',
    'กุมภาพันธ์',
    'มีนาคม',
    'เมษายน',
    'พฤษภาคม',
    'มิถุนายน',
    'กรกฎาคม',
    'สิงหาคม',
    'กันยายน',
    'ตุลาคม',
    'พฤศจิกายน',
    'ธันวาคม'
  ];

  @override
  void initState() {
    super.initState();
    startYear = widget.initialStartYear;
    startMonth = widget.initialStartMonth;
    endYear = widget.initialEndYear;
    endMonth = widget.initialEndMonth;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('เลือกช่วงเดือนและปี'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('เดือนและปีเริ่มต้น'),
          DropdownButton<int>(
            value: startYear,
            items: List.generate(
              10,
              (index) => DropdownMenuItem(
                value: DateTime.now().year - index,
                child: Text('${DateTime.now().year - index}'),
              ),
            ),
            onChanged: (value) => setState(() => startYear = value!),
          ),
          DropdownButton<int>(
            value: startMonth,
            items: List.generate(
              12,
              (index) => DropdownMenuItem(
                value: index + 1,
                child: Text(thaiMonths[index]),
              ),
            ),
            onChanged: (value) => setState(() => startMonth = value!),
          ),
          const Text('เดือนและปีสิ้นสุด'),
          DropdownButton<int>(
            value: endYear,
            items: List.generate(
              10,
              (index) => DropdownMenuItem(
                value: DateTime.now().year - index,
                child: Text('${DateTime.now().year - index}'),
              ),
            ),
            onChanged: (value) => setState(() => endYear = value!),
          ),
          DropdownButton<int>(
            value: endMonth,
            items: List.generate(
              12,
              (index) => DropdownMenuItem(
                value: index + 1,
                child: Text(thaiMonths[index]),
              ),
            ),
            onChanged: (value) => setState(() => endMonth = value!),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.of(context)
              .pop([startYear, startMonth, endYear, endMonth]),
          child: const Text('ตกลง'),
        ),
      ],
    );
  }
}
