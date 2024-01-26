import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/analytic/analytic_bloc.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/customer/customer_bloc.dart';
import '../../bloc/department/department_bloc.dart';
import '../../bloc/invoice/invoice_bloc.dart';
import '../../bloc/product/product_bloc.dart';
import '../analytic/analytic_screen.dart';
import '../bill_history/bill_history_screen.dart';
import '../create_bill/createbill_screen.dart';
import '../manage_product/manage_product_screen.dart';
import 'mainmenu_screen.dart';

extension MainMenuNavigation on MainMenuScreen {
  void navigateToCreateBillScreen(BuildContext context, int displayInvoiceId) {
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
            customer,
            invoice: null,
            displayInvoiceId: displayInvoiceId,
          ),
        ),
      ),
    );
  }

  void navigateToBillHistoryScreen(BuildContext context) {
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
          child: BillHistoryScreen(customer),
        ),
      ),
    );
  }

  void navigateToManageProductScreen(BuildContext context) {
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
          child: ManageProductScreen(customer),
        ),
      ),
    );
  }

  void navigateToAnalyticScreen(BuildContext context) {
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
          child: const AnalyticScreen(),
        ),
      ),
    );
  }

}