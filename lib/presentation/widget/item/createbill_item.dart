import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../domain/entity/product.dart';

class CreateBillItem extends StatefulWidget {
  final Product product;
  final int quantity;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onDelete;
  final Function(int) onChangeQuantity;
  final Function(double) onChangePrice;

  const CreateBillItem({
    Key? key,
    required this.product,
    required this.quantity,
    required this.onIncrease,
    required this.onDecrease,
    required this.onDelete,
    required this.onChangePrice,
    required this.onChangeQuantity,
  }) : super(key: key);

  @override
  State<CreateBillItem> createState() => _CreateBillItemState();
}

class _CreateBillItemState extends State<CreateBillItem> {
  bool isEditingQuantity = false;
  bool isEditingPrice = false;

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

  Widget _buildTextContainer(double width, String text, bool isEditable ,bool isPrice) {
    final double _commonHeight = 48;

    if (!isEditable) {
      return Container(
        decoration: BoxDecoration(border: Border.all()),
        width: width,
        height: _commonHeight, // Set the common height here
        alignment: Alignment.center, // To center the text vertically and horizontally
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
          textAlign: TextAlign.center,
        ),
      );
    }

    return GestureDetector(
      onDoubleTap: () {
        if (!isPrice) {
          setState(() => isEditingQuantity = true);
        } else if (isPrice) {
          setState(() => isEditingPrice = true);
        }
      },
      child: Stack(
        children: [
          Visibility(
            visible: (!isPrice && !isEditingQuantity) ||
                (isPrice && !isEditingPrice),
            child: Container(
              decoration: BoxDecoration(border: Border.all()),
              width: width,
              height: _commonHeight,
              alignment: Alignment.center,
              child: Text(
                text,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          if (!isPrice && isEditingQuantity)
            _buildEditableTextField(width, text, isPrice),
          if (isPrice && isEditingPrice)
            _buildEditableTextField(width, text, isPrice),
        ],
      ),
    );
  }

  Widget _buildEditableTextField(double width, String text, bool isPrice) {
    TextEditingController controller = TextEditingController(text: text);
    return Container(
      width: width,
      height: 48,
      child: TextField(
        controller: controller,
        inputFormatters: [
          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // Allow only digits
        ],
        onSubmitted: (newValue) {
          if (!isPrice) {
            var newValueInt = int.parse(newValue);
            setState(() => isEditingQuantity = false);
            widget.onChangeQuantity(newValueInt);
          } else if (isPrice) {
            var newValueDouble = double.parse(newValue);
            setState(() => isEditingPrice = false);
            widget.onChangePrice(newValueDouble);
          }
        },
        autofocus: true,
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
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, // Remove padding to fill the container
              primary: Colors.black, // Text color
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero), // Match the container border
            ),
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: Colors.black), // Ensure text color is visible
              textAlign: TextAlign.center,
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
          _buildTextContainer(widthFactor * 0.2, widget.product.name, false, false),
          _buildTextContainer(widthFactor * 0.1, widget.product.unit, false, false),
          _buildTextContainer(widthFactor * 0.1, widget.quantity.toString(), true, false),
          _buildTextContainer(widthFactor * 0.1, widget.product.price.toString(), true, true),
          _buildTextContainer(widthFactor * 0.2, (widget.product.price * widget.quantity).toString(), false, false),
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
