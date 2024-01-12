import 'package:flowerstore/data/datasource/customer/model/patch_customer_request.dart';
import 'package:flowerstore/helper/customer_store.dart';
import 'package:flutter/material.dart';

class PatchCustomerDialog extends StatefulWidget {
  final Function(PatchCustomerRequest) onSubmit;
  final String initialName;
  final String initialAddress;
  final String initialPhone;

  const PatchCustomerDialog({
    super.key,
    required this.onSubmit,
    this.initialName = '',
    this.initialAddress = '',
    this.initialPhone = '',
  });

  @override
  PatchCustomerDialogState createState() => PatchCustomerDialogState();
}

class PatchCustomerDialogState extends State<PatchCustomerDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.initialName);
    addressController = TextEditingController(text: widget.initialAddress);
    phoneController = TextEditingController(text: widget.initialPhone);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('ข้อมูลลูกค้า', style: Theme.of(context).textTheme.bodyLarge),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อ',
                ),
                style: Theme.of(context).textTheme.bodyLarge),
            TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'ที่อยู่',
                ),
                style: Theme.of(context).textTheme.bodyLarge),
            TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'เบอร์โทร',
                ),
                style: Theme.of(context).textTheme.bodyLarge),
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
          onPressed: () {
            String name = nameController.text;
            String address = addressController.text;
            String phone = phoneController.text;

            final customerId = CustomerStore.getCustomerId();

            if (customerId != null) {
              widget.onSubmit(PatchCustomerRequest(
                name: name,
                address: address,
                phone: phone,
                customerId: customerId,
              ));
            }

            Navigator.of(context).pop();
          },
          child: Text(
            'แก้ไข',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
