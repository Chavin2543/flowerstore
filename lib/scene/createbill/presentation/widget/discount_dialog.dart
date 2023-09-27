import 'package:flutter/material.dart';

class DiscountDialog extends StatefulWidget {
  final double total;
  final Function(double) onSubmit;

  const DiscountDialog({
    Key? key,
    required this.total,
    required this.onSubmit,
  }) : super(key: key);

  @override
  _DiscountDialogState createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  TextEditingController discountController = TextEditingController();
  DiscountType _discountType = DiscountType.percent; // default to percent

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('เลือกส่วนลด'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: discountController,
              decoration: const InputDecoration(
                labelText: 'ส่วนลด',
              ),
              keyboardType: TextInputType.number, // only allow number inputs
            ),
            ValueListenableBuilder(
              valueListenable: discountController,
              builder: (context, value, child) {
                double discountValue = 0.0;
                String text = value.text;
                if (text.isNotEmpty && double.tryParse(text) != null) {
                  discountValue = double.parse(text);
                  if (_discountType == DiscountType.percent) {
                    discountValue = widget.total * discountValue / 100;
                  }
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(),
                    Text(
                      'ลดเป็นเงิน: ${discountValue.toStringAsFixed(2)} บาท',
                      textAlign: TextAlign.start,
                    ),
                    Text(
                      'ลดเหลือ: ${(widget.total - discountValue).toStringAsFixed(2)} บาท',
                      textAlign: TextAlign.start,
                    ),
                  ],
                );
              },
            ),
            ListTile(
              title: const Text('เปอร์เซ็นตฺ์'),
              leading: Radio<DiscountType>(
                value: DiscountType.percent,
                groupValue: _discountType,
                onChanged: (DiscountType? value) {
                  setState(() {
                    _discountType = value!;
                  });
                },
              ),
            ),
            ListTile(
              title: const Text('จำนวนเงิน'),
              leading: Radio<DiscountType>(
                value: DiscountType.amount,
                groupValue: _discountType,
                onChanged: (DiscountType? value) {
                  setState(() {
                    _discountType = value!;
                  });
                },
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('ยกเลิก'),
        ),
        TextButton(
          onPressed: () {
            if (discountController.text.isNotEmpty) {
              widget.onSubmit(
                double.parse(discountController.text),
              );
              Navigator.of(context).pop();
            }
          },
          child: const Text('ออกบิล'),
        ),
      ],
    );
  }
}

enum DiscountType { percent, amount }
