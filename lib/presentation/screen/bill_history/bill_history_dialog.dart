import 'package:flowerstore/presentation/screen/bill_history/bill_history_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/invoice.dart';
import '../../bloc/analytic/analytic_bloc.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/customer/customer_bloc.dart';
import '../../bloc/department/department_bloc.dart';
import '../../bloc/invoice/invoice_bloc.dart';
import '../../bloc/product/product_bloc.dart';
import '../../widget/dialog/invoice_option_dialog.dart';

extension BillHistoryDialog on BillHistoryScreenState {
  void showInvoiceOptionDialog(Invoice invoice) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<CustomerBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<ProductBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<CategoryBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<InvoiceBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<AnalyticBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<DepartmentBloc>(context)),
          ],
          child: InvoiceOptionDialog(
            invoice: invoice,
            customer: widget.customer,
          ),
        );
      },
    );
  }
}