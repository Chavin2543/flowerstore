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
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitController = TextEditingController();

  void handleSubmit() {
    String name = nameController.text;
    double price = double.parse(priceController.text);
    int quantity = int.parse(quantityController.text);
    String unit = unitController.text;

    // Invoke the callback with the post request model
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

  @override
  void initState() {
    if (widget.product != null) {
      nameController.text = widget.product?.name ?? "";
      priceController.text = widget.product?.price.toString() ?? "";
      unitController.text = widget.product?.unit ?? "";
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('เพิ่มสินค้า'),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'ชื่อ',
              ),
              onSubmitted: (text) => handleSubmit(),
            ),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'ราคา',
              ),
              onSubmitted: (text) => handleSubmit(),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'จำนวน',
              ),
              onSubmitted: (text) => handleSubmit(),
            ),
            TextField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText: 'หน่วย',
              ),
              onSubmitted: (text) => handleSubmit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('ยกเลิก', style: Theme.of(context).textTheme.displayLarge,),
        ),
        TextButton(
          onPressed: () { handleSubmit(); },
          child: Text('เพิ่ม', style: Theme.of(context).textTheme.displayLarge,),
        ),
      ],
    );
  }
}
