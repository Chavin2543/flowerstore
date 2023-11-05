import 'package:flutter/material.dart';

import '../../../domain/entity/product.dart';

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
  late Map<ActionType, bool> _hoveringStates;

  @override
  void initState() {
    super.initState();
    _hoveringStates = {
      ActionType.decrease: false,
      ActionType.increase: false,
      ActionType.delete: false,
    };
  }

  void _onEnter(ActionType actionType) => setState(() => _hoveringStates[actionType] = true);

  void _onExit(ActionType actionType) => setState(() => _hoveringStates[actionType] = false);

  Widget _buildTextContainer(double width, String text) {
    final double _commonHeight = 48;

    return Container(
      decoration: BoxDecoration(border: Border.all()),
      width: width,
      height: _commonHeight, // Set the common height here
      alignment: Alignment.center, // To center the text vertically and horizontally
      child: Text(
        text,
        style: Theme.of(context).textTheme.displayLarge,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildActionButton(
      double width,
      String label,
      ActionType actionType,
      VoidCallback onPressed,
      ) {
    final double _commonHeight = 48;

    return MouseRegion(
      onEnter: (_) => _onEnter(actionType),
      onExit: (_) => _onExit(actionType),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(),
            color: _hoveringStates[actionType]!
                ? Theme.of(context).colorScheme.primary
                : Colors.transparent,
          ),
          width: width,
          height: _commonHeight, // Set the common height here
          child: TextButton(
            onPressed: onPressed,
            child: Text(
              label,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(color: Colors.black), // Ensure text color is visible
              textAlign: TextAlign.center,
            ),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, // Remove padding to fill the container
              primary: Colors.black, // Text color
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Match the container border
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, boxConstraints) {
      final widthFactor = boxConstraints.maxWidth;
      return Row(
        children: [
          _buildTextContainer(widthFactor * 0.2, widget.product.name),
          _buildTextContainer(widthFactor * 0.1, widget.product.unit),
          _buildTextContainer(widthFactor * 0.1, widget.quantity.toString()),
          _buildTextContainer(widthFactor * 0.1, widget.product.price.toString()),
          _buildTextContainer(widthFactor * 0.2, (widget.product.price * widget.quantity).toString()),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
            child: Row(
              children: [
                _buildActionButton(widthFactor * 0.1, "ลด", ActionType.decrease, widget.onDecrease),
                _buildActionButton(widthFactor * 0.1, "เพิ่ม", ActionType.increase, widget.onIncrease),
                _buildActionButton(widthFactor * 0.1, "ลบ", ActionType.delete, widget.onDelete),
              ],
            ),
          ),
        ],
      );
    });
  }
}

enum ActionType {
  decrease,
  increase,
  delete,
}
