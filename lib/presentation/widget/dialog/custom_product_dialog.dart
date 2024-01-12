import 'package:flowerstore/domain/entity/bill_item.dart';
import 'package:flutter/material.dart';

import '../../../domain/entity/product.dart';

class CustomProductDialog extends StatefulWidget {
  final Product product;
  final Function(BillItem) onSubmit;

  const CustomProductDialog({
    super.key,
    required this.onSubmit,
    required this.product,
  });

  @override
  CustomProductDialogState createState() => CustomProductDialogState();
}

class CustomProductDialogState extends State<CustomProductDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  void handleSubmit() {
    if (_formKey.currentState!.validate()) {
      String name = nameController.text;
      double price = double.tryParse(priceController.text) ?? 0;
      int quantity = int.tryParse(quantityController.text) ?? 0;
      String unit = unitController.text;

      widget.onSubmit(
        BillItem(
          product: Product(
            id: widget.product.id,
            name: name,
            categoryId: widget.product.categoryId,
            customerId: widget.product.customerId,
            price: price,
            unit: unit,
          ),
          quantity: quantity,
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      nameController.text = widget.product.name;
      priceController.text = widget.product.price.toString();
      unitController.text = widget.product.unit;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('เพิ่มสินค้า', style: Theme.of(context).textTheme.bodyLarge,),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'ชื่อ'),
                onFieldSubmitted: (text) => handleSubmit(),
                style: Theme.of(context).textTheme.bodyLarge
              ),
              TextFormField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'ราคา'),
                keyboardType: TextInputType.number,
                onFieldSubmitted: (text) => handleSubmit(),
                  style: Theme.of(context).textTheme.bodyLarge
              ),
              TextFormField(
                  autofocus: true,
                controller: quantityController,
                decoration: const InputDecoration(labelText: 'จำนวน'),
                keyboardType: TextInputType.number,
                onFieldSubmitted: (text) => handleSubmit(),
                  style: Theme.of(context).textTheme.bodyLarge
              ),
              TextFormField(
                controller: unitController,
                decoration: const InputDecoration(labelText: 'หน่วย'),
                onFieldSubmitted: (text) => handleSubmit(),
                  style: Theme.of(context).textTheme.bodyLarge
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('ยกเลิก', style: Theme.of(context).textTheme.bodyLarge),
        ),
        TextButton(
          onPressed: handleSubmit,
          child: Text('เพิ่ม', style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
