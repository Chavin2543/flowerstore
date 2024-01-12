import 'package:flutter/material.dart';

class ProductItem extends StatefulWidget {
  final String name;
  final String? unit;
  final double? price;
  final VoidCallback onTap;
  final bool isSelected;

  const ProductItem({
    Key? key,
    required this.name,
    this.unit,
    this.price,
    required this.onTap,
    required this.isSelected,
  }) : super(key: key);

  @override
  ProductItemState createState() => ProductItemState();
}

class ProductItemState extends State<ProductItem> {
  bool _isHovering = false;
  bool _isCategory = false;

  @override
  void initState() {
    if (widget.price == null && widget.unit == null) {
      _isCategory = true;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      return MouseRegion(
        onHover: (event) => setState(() => _isHovering = true),
        onExit: (event) => setState(() => _isHovering = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: Container(
              decoration: BoxDecoration(
                color: _isHovering || widget.isSelected ? Colors.grey : Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    width: _isCategory ? boxConstraints.maxWidth : boxConstraints.maxWidth / 3,
                    child: Text(
                      widget.name,
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (!_isCategory)
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    width: boxConstraints.maxWidth / 3,
                    child: Text(
                      " (${widget.unit})",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  if (!_isCategory)
                  Container(
                    decoration: BoxDecoration(border: Border.all()),
                    width: boxConstraints.maxWidth / 3,
                    child: Text(
                      "${widget.price.toString()} ",
                      style: Theme.of(context).textTheme.bodyLarge,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              )),
        ),
      );
    });
  }
}
