import 'package:flutter/material.dart';

class CreateBillItem extends StatelessWidget {
  const CreateBillItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            Text(
              "1 x ",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(
              "ดอกกุหลาบ",
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ],
        ),
      ),
    );
  }
}
