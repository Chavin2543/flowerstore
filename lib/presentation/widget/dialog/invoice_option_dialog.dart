import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasource/invoice/model/request/delete_invoice_request.dart';
import '../../../data/datasource/invoice/model/request/patch_invoice_request.dart';
import '../../../domain/entity/customer.dart';
import '../../../domain/entity/invoice.dart';
import '../../bloc/analytic/analytic_bloc.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/customer/customer_bloc.dart';
import '../../bloc/department/department_bloc.dart';
import '../../bloc/invoice/invoice_bloc.dart';
import '../../bloc/product/product_bloc.dart';
import '../../screen/create_bill/createbill_screen.dart';

class InvoiceOptionDialog extends StatefulWidget {
  const InvoiceOptionDialog({
    super.key,
    required this.invoice,
    required this.customer,
  });

  final Invoice invoice;
  final Customer customer;

  @override
  InvoiceOptionDialogState createState() => InvoiceOptionDialogState();
}

class InvoiceOptionDialogState extends State<InvoiceOptionDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController invoiceIdController = TextEditingController();

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<InvoiceBloc>(context).add(
        PatchInvoiceEvent(
          request: PatchInvoiceRequest(
            invoiceId: widget.invoice.id,
            total: widget.invoice.total,
            displayInvoiceId: int.parse(
              invoiceIdController.text,
            ),
          ),
        ),
      );
      Navigator.of(context).pop();
    }
  }

  @override
  void initState() {
    super.initState();
    invoiceIdController.text = widget.invoice.invoiceId.toString();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'จัดการบิลนี้',
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      content: Form(
        key: _formKey,
        child: TextField(
          controller: invoiceIdController,
          decoration: const InputDecoration(labelText: 'หมายเลขบิล (แก้ได้)'),
          keyboardType: TextInputType.number,
          autofocus: true,
          onSubmitted: (_) => _submitForm(),
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: Text(
            'ดูบิล',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          onPressed: () {
            Navigator.of(context).pop();
            _navigateToCreateBillScreen(
              widget.invoice.id,
              widget.invoice.invoiceId,
            );
          },
        ),
        TextButton(
          child: Text(
            'แก้ไขหมายเลข',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          onPressed: () {
            BlocProvider.of<InvoiceBloc>(context).add(
              PatchInvoiceEvent(
                request: PatchInvoiceRequest(
                  invoiceId: widget.invoice.id,
                  total: widget.invoice.total,
                  displayInvoiceId: int.parse(
                    invoiceIdController.text,
                  ),
                ),
              ),
            );
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text(
            'ลบบิล',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          onPressed: () {
            BlocProvider.of<InvoiceBloc>(context).add(
              DeleteInvoiceEvent(
                request: DeleteInvoiceRequest(
                  invoiceId: widget.invoice.id,
                ),
              ),
            );
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('ปิด'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  void _navigateToCreateBillScreen(int invoiceId, int displayInvoiceId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (navigatorContext) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<CustomerBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<ProductBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<CategoryBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<InvoiceBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<AnalyticBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<DepartmentBloc>(context)),
          ],
          child: CreateBillScreen(
            widget.customer,
            invoice: widget.invoice,
            displayInvoiceId: displayInvoiceId,
          ),
        ),
      ),
    );
  }
}
