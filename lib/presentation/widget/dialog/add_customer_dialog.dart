import 'package:flowerstore/data/datasource/customer/model/add_customer_request.dart';
import 'package:flutter/material.dart';

class AddCustomerDialog extends StatefulWidget {
  final Function(AddCustomerRequest) onSubmit;

  const AddCustomerDialog({super.key, required this.onSubmit});

  @override
  AddCustomerDialogState createState() => AddCustomerDialogState();
}

class AddCustomerDialogState extends State<AddCustomerDialog> {
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

            widget.onSubmit(AddCustomerRequest(
              name: name,
              address: address,
              phone: phone,
            ));

            Navigator.of(context).pop();
          },
          child: const Text('เพิ่ม'),
        ),
      ],
    );
  }
}
