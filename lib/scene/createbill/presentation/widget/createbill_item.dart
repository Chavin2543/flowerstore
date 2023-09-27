import 'package:flowerstore/scene/createbill/data/model/product.dart';
import 'package:flutter/material.dart';

class CreateBillItem extends StatefulWidget {
  final Product product;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;

  const CreateBillItem({
    Key? key,
    required this.product,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
  }) : super(key: key);

  @override
  State<CreateBillItem> createState() => _CreateBillItemState();
}

class _CreateBillItemState extends State<CreateBillItem> {
  bool _isHoveringDecrease = false;
  bool _isHoveringIncrease = false;
  bool _isHoveringDelete = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return Row(
        children: [
          Container(
            decoration: BoxDecoration(border: Border.all()),
            width: boxConstraints.maxWidth * 0.2,
            child: Text(
              widget.product.name,
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            width: boxConstraints.maxWidth * 0.1,
            child: Text(
              widget.product.unit,
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            width: boxConstraints.maxWidth * 0.1,
            child: Text(
              widget.quantity.toString(),
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            width: boxConstraints.maxWidth * 0.1,
            child: Text(
              widget.product.price.toString(),
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            decoration: BoxDecoration(border: Border.all()),
            width: boxConstraints.maxWidth * 0.2,
            child: Text(
              (widget.product.price * widget.quantity).toString(),
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                MouseRegion(
                  onEnter: (_) => setState(() => _isHoveringDecrease = true),
                  onExit: (_) => setState(() => _isHoveringDecrease = false),
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: _isHoveringDecrease
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                      ),
                      width: boxConstraints.maxWidth * 0.1,
                      child: TextButton(
                        onPressed: widget.onDecrease,
                        child: Text(
                          "ลด",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    ),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) => setState(() => _isHoveringIncrease = true),
                  onExit: (_) => setState(() => _isHoveringIncrease = false),
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: _isHoveringIncrease
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                      ),
                      width: boxConstraints.maxWidth * 0.1,
                      child: TextButton(
                        onPressed: widget.onIncrease,
                        child: Text(
                          "เพิ่ม",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    ),
                  ),
                ),
                MouseRegion(
                  onEnter: (_) => setState(() => _isHoveringDelete = true),
                  onExit: (_) => setState(() => _isHoveringDelete = false),
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(),
                        color: _isHoveringDelete
                            ? Theme.of(context).colorScheme.primary
                            : Colors.transparent,
                      ),
                      width: boxConstraints.maxWidth * 0.1,
                      child: TextButton(
                        onPressed: widget.onDelete,
                        child: Text(
                          "ลบ",
                          style: Theme.of(context).textTheme.displayLarge,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
