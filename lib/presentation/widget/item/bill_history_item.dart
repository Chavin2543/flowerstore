import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../domain/entity/invoice.dart';

class BillHistoryItem extends StatefulWidget {
  const BillHistoryItem(this.invoice, this.onTap, {Key? key}) : super(key: key);

  final Invoice invoice;
  final VoidCallback onTap;

  @override
  State<BillHistoryItem> createState() => _BillHistoryItemState();
}

class _BillHistoryItemState extends State<BillHistoryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat('d MMMM y', 'th').format(widget.invoice.date); // Format the date

    return LayoutBuilder(
      builder: (context, boxConstraints) {
        return MouseRegion(
          onHover: (event) => setState(() => _isHovered = true),
          onExit: (event) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: Container(
              decoration: BoxDecoration(
                color: _isHovered ? Colors.grey : Colors.white,
              ),
              child: Row(
                children: [
                  Container(
                    height: 60.0,  // Height is set
                    alignment: Alignment.center,  // <-- Added alignment
                    decoration: BoxDecoration(border: Border.all()),
                    width: boxConstraints.maxWidth / 3,
                    child: Text(
                      widget.invoice.invoiceId.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    height: 60.0,  // Height is set
                    alignment: Alignment.center,  // <-- Added alignment
                    decoration: BoxDecoration(border: Border.all()),
                    width: boxConstraints.maxWidth / 3,
                    child: Text(
                      formattedDate,
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                  Container(
                    height: 60.0,  // Height is set
                    alignment: Alignment.center,  // <-- Added alignment
                    decoration: BoxDecoration(border: Border.all()),
                    width: boxConstraints.maxWidth / 3,
                    child: Text(
                      widget.invoice.total.toString(),
                      style: const TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
