import 'package:flowerstore/scene/createbill/data/model/product.dart';
import 'package:flowerstore/scene/createbill/presentation/bloc/category/entity/bill_item_model.dart';
import 'package:flutter/material.dart';

class CustomProductDialog extends StatefulWidget {
  final Product product;
  final Function(BillItemModel) onSubmit;

  const CustomProductDialog({
    super.key,
    required this.onSubmit,
    required this.product,
  });

  @override
  _CustomProductDialogState createState() => _CustomProductDialogState();
}

class _CustomProductDialogState extends State<CustomProductDialog> {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController unitController = TextEditingController();

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
      title: const Text('สินค้าชั่วคราว'),
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
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'ราคา',
              ),
            ),
            TextField(
              controller: quantityController,
              decoration: const InputDecoration(
                labelText: 'จำนวน',
              ),
            ),
            TextField(
              controller: unitController,
              decoration: const InputDecoration(
                labelText: 'หน่วย',
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
            double price = double.parse(priceController.text);
            int quantity = int.parse(quantityController.text);
            String unit = unitController.text;

            // Invoke the callback with the post request model
            widget.onSubmit(
              BillItemModel(
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
          },
          child: const Text('เพิ่ม'),
        ),
      ],
    );
  }
}
