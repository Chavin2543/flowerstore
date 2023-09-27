import 'package:flowerstore/scene/billhistory/model/invoice.dart';
import 'package:flutter/material.dart';

class BillHistoryItem extends StatefulWidget {
  const BillHistoryItem(this.invoice, {Key? key}) : super(key: key);

  final Invoice invoice;

  @override
  State<BillHistoryItem> createState() => _BillHistoryItemState();
}

class _BillHistoryItemState extends State<BillHistoryItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Card(
          color: _isHovered ? Theme.of(context).colorScheme.primary : Colors.white,
          child: ListTile(
            title: Text('บิลที่: ${widget.invoice.id}', style: Theme.of(context).textTheme.headlineLarge,),
            subtitle: Text('วันที่: ${widget.invoice.date}', style: Theme.of(context).textTheme.headlineLarge,),
            trailing: Text('จำนวนเงิน: ${widget.invoice.total}', style: Theme.of(context).textTheme.headlineLarge,),
          ),
        ),
      ),
    );
  }
}
