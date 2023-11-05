import 'package:flutter/material.dart';

class MonthPickerButton extends StatelessWidget {
  final Function(int?, int?) onMonthRangePicked;

  const MonthPickerButton({required this.onMonthRangePicked});

  @override
  Widget build(BuildContext context) {
    final thaiMonths = [
      'มกราคม', 'กุมภาพันธ์', 'มีนาคม', 'เมษายน', 'พฤษภาคม', 'มิถุนายน',
      'กรกฎาคม', 'สิงหาคม', 'กันยายน', 'ตุลาคม', 'พฤศจิกายน', 'ธันวาคม'
    ];

    return ElevatedButton(
      onPressed: () async {
        final picked = await showDialog<List<int>>(
          context: context,
          builder: (context) {
            int startMonth = 1;
            int endMonth = 12;

            return AlertDialog(
              title: Text('เลือกช่วงเดือน'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('เดือนเริ่มต้น'),
                  DropdownButton<int>(
                    value: startMonth,
                    items: List.generate(
                      12,
                          (index) => DropdownMenuItem(
                        child: Text('${thaiMonths[index]}'),
                        value: index + 1,
                      ),
                    ),
                    onChanged: (value) {
                      if (value != null) startMonth = value;
                    },
                  ),
                  Text('เดือนสิ้นสุด'),
                  DropdownButton<int>(
                    value: endMonth,
                    items: List.generate(
                      12,
                          (index) => DropdownMenuItem(
                        child: Text('${thaiMonths[index]}'),
                        value: index + 1,
                      ),
                    ),
                    onChanged: (value) {
                      if (value != null) endMonth = value;
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop([startMonth, endMonth]);
                  },
                  child: Text('ตกลง'),
                ),
              ],
            );
          },
        );

        if (picked != null && picked.length == 2) {
          onMonthRangePicked(picked[0], picked[1]);
        }
      },
      child: Text('เลือกช่วงเดือน'),
    );
  }
}
