import 'package:flutter/material.dart';

import '../../../domain/entity/product.dart';

class ManageProductItem extends StatelessWidget {
  final Product product;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const ManageProductItem(this.product, this.onDelete, this.onEdit, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(border: Border.all(), color: Colors.white),
      child: LayoutBuilder(
        builder: (context, boxConstraints) {
          return Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                ),
                width: boxConstraints.maxWidth * 0.4,
                child: Text(
                  product.name,
                  style: Theme.of(context).textTheme.displayLarge,
                  textAlign: TextAlign.center,
                ),
              ),
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  width: boxConstraints.maxWidth * 0.2,
                  child: Text(
                    product.unit,
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  )),
              Container(
                  decoration: BoxDecoration(
                    border: Border.all(),
                  ),
                  width: boxConstraints.maxWidth * 0.2,
                  child: Text(
                    product.price.toString(),
                    style: Theme.of(context).textTheme.displayLarge,
                    textAlign: TextAlign.center,
                  )),
              Container(
                decoration: const BoxDecoration(
                    color: Colors.red
                ),
                width: boxConstraints.maxWidth * 0.1,
                child: TextButton(
                    onPressed: onDelete,
                    child: Text(
                      "ลบ",
                      style: Theme.of(context).textTheme.displayLarge,
                    )),
              ),
              Container(
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary
                ),
                width: boxConstraints.maxWidth * 0.1,
                child: TextButton(
                    onPressed: onEdit,
                    child: Text(
                      "แก้ไข",
                      style: Theme.of(context).textTheme.displayLarge,
                    )),
              )
            ],
          );
        },
      ),
    );
  }
}
