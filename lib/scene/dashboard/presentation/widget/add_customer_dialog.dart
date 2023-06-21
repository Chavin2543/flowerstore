import 'package:flowerstore/scene/dashboard/data/model/add_customer.dart';
import 'package:flutter/material.dart';

class AddCustomerDialog extends StatefulWidget {
  final Function(AddCustomer) onSubmit;

  AddCustomerDialog({required this.onSubmit});

  @override
  _AddCustomerDialogState createState() => _AddCustomerDialogState();
}

class _AddCustomerDialogState extends State<AddCustomerDialog> {
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

            AddCustomer requestModel = AddCustomer(
              name: name,
              address: address,
              phone: phone,
            );

            // Invoke the callback with the post request model
            widget.onSubmit(requestModel);
            Navigator.of(context).pop();
          },
          child: const Text('เพิ่ม'),
        ),
      ],
    );
  }
}
