import 'package:flowerstore/data/datasource/customer/model/add_customer_request.dart';
import 'package:flutter/material.dart';

class AddCustomerDialog extends StatefulWidget {
  final Function(AddCustomerRequest) onSubmit;

  const AddCustomerDialog({super.key, required this.onSubmit});

  @override
  AddCustomerDialogState createState() => AddCustomerDialogState();
}

class AddCustomerDialogState extends State<AddCustomerDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      String name = nameController.text;
      String address = addressController.text;
      String phone = phoneController.text;
      widget.onSubmit(AddCustomerRequest(
        name: name,
        address: address,
        phone: phone,
      ));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('ข้อมูลลูกค้า'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'ชื่อ',
                ),
                onSubmitted: (_) => _submitForm(),
              ),
              TextField(
                controller: addressController,
                decoration: const InputDecoration(
                  labelText: 'ที่อยู่',
                ),
                onSubmitted: (_) => _submitForm(),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'เบอร์โทร',
                ),
                onSubmitted: (_) => _submitForm(),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('ยกเลิก',  style: Theme.of(context).textTheme.bodyLarge),
        ),
        TextButton(
          onPressed: _submitForm,
          child: Text('เพิ่ม', style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}

