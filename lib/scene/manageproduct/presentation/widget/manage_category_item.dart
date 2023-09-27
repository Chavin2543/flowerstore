import 'package:flowerstore/scene/createbill/presentation/bloc/category/category_bloc.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../createbill/data/model/category.dart';

class ManageCategoryItem extends StatefulWidget {
  final Category category;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final Function(Category) onTapCategory;
  final bool isSelected;

  const ManageCategoryItem(
      this.category, this.onDelete, this.onEdit, this.onTapCategory, this.isSelected,
      {Key? key})
      : super(key: key);

  @override
  _ManageCategoryItemState createState() => _ManageCategoryItemState();
}

class _ManageCategoryItemState extends State<ManageCategoryItem> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (PointerEnterEvent event) {
        setState(() {
          _isHovering = true;
        });
      },
      onExit: (PointerExitEvent event) {
        setState(() {
          _isHovering = false;
        });
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(),
            color: _isHovering || widget.isSelected ? Colors.grey[300] : Colors.white),
        child: LayoutBuilder(
          builder: (context, boxConstraints) {
            return Row(
              children: [
                GestureDetector(
                  onTap: () {
                    widget.onTapCategory(widget.category);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(),
                    ),
                    width: boxConstraints.maxWidth * 0.6,
                    child: Text(
                      widget.category.name,
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    border: Border.all(),
                  ),
                  width: boxConstraints.maxWidth * 0.2,
                  child: TextButton(
                      onPressed: widget.onDelete,
                      child: Text(
                        "ลบ",
                        style: Theme.of(context).textTheme.displayLarge,
                      )),
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    border: Border.all(),
                  ),
                  width: boxConstraints.maxWidth * 0.2,
                  child: TextButton(
                      onPressed: widget.onEdit,
                      child: Text(
                        "แก้ไข",
                        style: Theme.of(context).textTheme.displayLarge,
                      )),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
