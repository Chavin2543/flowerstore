import 'package:flowerstore/scene/dashboard/data/model/patch_customer.dart';
import 'package:flutter/material.dart';

class PatchCustomerDialog extends StatefulWidget {
  final Function(PatchCustomer) onSubmit;

  PatchCustomerDialog({super.key, required this.onSubmit});

  @override
  _PatchCustomerDialogState createState() => _PatchCustomerDialogState();
}

class _PatchCustomerDialogState extends State<PatchCustomerDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ข้อมูลลูกค้า'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อ',
              ),
            ),
            TextField(
              controller: addressController,
              decoration: const InputDecoration(
                labelText: 'ที่อยู่',
              ),
            ),
            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: 'เบอร์โทร',
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
            String name = nameController.text;
            String address = addressController.text;
            String phone = phoneController.text;

            PatchCustomer requestModel = PatchCustomer(
              name: name,
              address: address,
              phone: phone,
            );

            // Invoke the callback with the post request model
            widget.onSubmit(requestModel);
            Navigator.of(context).pop();
          },
          child: const Text('แก้ไข'),
        ),
      ],
    );
  }
}
