import 'package:flowerstore/presentation/bloc/department/department_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

import '../../../domain/entity/department.dart';
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
                    width: boxConstraints.maxWidth / 7,
                    child: Text(
                      widget.invoice.invoiceId.toString(),
                        style: Theme.of(context).textTheme.bodyLarge
                    ),
                  ),
                  Container(
                    height: 60.0,  // Height is set
                    alignment: Alignment.center,  // <-- Added alignment
                    decoration: BoxDecoration(border: Border.all()),
                    width: boxConstraints.maxWidth / 7,
                    child: Text(
                      formattedDate,
                        style: Theme.of(context).textTheme.bodyLarge
                    ),
                  ),
                  Container(
                    height: 60.0,  // Height is set
                    alignment: Alignment.center,  // <-- Added alignment
                    decoration: BoxDecoration(border: Border.all()),
                    width: boxConstraints.maxWidth / 7,
                    child: Text(
                        widget.invoice.biller.isEmpty ? "ไม่ระบุ" : widget.invoice.biller,
                        style: Theme.of(context).textTheme.bodyLarge
                    ),
                  ),
                  BlocBuilder<DepartmentBloc, DepartmentState>(builder: (context, state) {
                    if (state is DepartmentLoaded) {
                      return  Container(
                        height: 60.0,  // Height is set
                        alignment: Alignment.center,  // <-- Added alignment
                        decoration: BoxDecoration(border: Border.all()),
                        width: boxConstraints.maxWidth / 7,
                        child: Text(
                            state.departments.firstWhere((element) => element.id == widget.invoice.departmentId, orElse: () => Department(id: -99, name: "ไม่ระบุ")).name,
                            style: Theme.of(context).textTheme.bodyLarge
                        ),
                      );
                    } else {
                      return Container(
                        height: 60.0,  // Height is set
                        alignment: Alignment.center,  // <-- Added alignment
                        decoration: BoxDecoration(border: Border.all()),
                        width: boxConstraints.maxWidth / 7,
                        child: Text(
                            "ไม่ระบุ",
                            style: Theme.of(context).textTheme.bodyLarge
                        ),
                      );
                    }
                  }),
                  Container(
                    height: 60.0,  // Height is set
                    alignment: Alignment.center,  // <-- Added alignment
                    decoration: BoxDecoration(border: Border.all()),
                    width: boxConstraints.maxWidth / 7,
                    child: Text(
                        widget.invoice.total.toString(),
                        style: Theme.of(context).textTheme.bodyLarge
                    ),
                  ),
                  Container(
                    height: 60.0,  // Height is set
                    alignment: Alignment.center,  // <-- Added alignment
                    decoration: BoxDecoration(border: Border.all()),
                    width: boxConstraints.maxWidth / 7,
                    child: Text(
                        widget.invoice.discount.toString(),
                        style: Theme.of(context).textTheme.bodyLarge
                    ),
                  ),
                  Container(
                    height: 60.0,  // Height is set
                    alignment: Alignment.center,  // <-- Added alignment
                    decoration: BoxDecoration(border: Border.all()),
                    width: boxConstraints.maxWidth / 7,
                    child: Text(
                        widget.invoice.discountedTotal.toString(),
                        style: Theme.of(context).textTheme.bodyLarge
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
