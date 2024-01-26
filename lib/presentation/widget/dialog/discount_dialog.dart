import 'package:flutter/material.dart';

class DiscountResult {
  final double discount;
  final double discountedTotal;

  DiscountResult({required this.discount, required this.discountedTotal});
}

class DiscountDialog extends StatefulWidget {
  final double total;
  final double oldDiscount;
  final Function(DiscountResult) onSubmit;

  const DiscountDialog({
    Key? key,
    required this.total,
    this.oldDiscount = 0.0,
    required this.onSubmit,
  }) : super(key: key);

  @override
  DiscountDialogState createState() => DiscountDialogState();
}

class DiscountDialogState extends State<DiscountDialog> {
  TextEditingController discountController = TextEditingController();
  DiscountType _discountType = DiscountType.percent;

  void _submitDiscount() {
    if (discountController.text.isNotEmpty) {
      double discountValue = double.parse(discountController.text);
      double discountedTotal = widget.total;

      if (_discountType == DiscountType.percent) {
        discountValue = widget.total * discountValue / 100;
        discountedTotal -= discountValue;
      } else {
        discountedTotal -= discountValue;
      }
      widget.onSubmit(DiscountResult(
          discount: discountValue, discountedTotal: discountedTotal));
    }
  }

  @override
  void initState() {
    super.initState();
    discountController.text = widget.oldDiscount.toString();
  }

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
              keyboardType: TextInputType.number,
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
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            'ยกเลิก',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        TextButton(
          onPressed: _submitDiscount,
          child: Text(
            'ออกบิล',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}

enum DiscountType { percent, amount }
