
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasource/department/model/get_department_request.dart';
import '../../../domain/entity/customer.dart';
import '../../../helper/customer_store.dart';
import '../../bloc/analytic/analytic_bloc.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/customer/customer_bloc.dart';
import '../../bloc/department/department_bloc.dart';
import '../../bloc/invoice/invoice_bloc.dart';
import '../../bloc/product/product_bloc.dart';
import '../mainmenu/mainmenu_screen.dart';
import '../summary_screen.dart';
import 'dashboard_screen.dart';

extension DashboardNavigation on DashboardScreenState {
  void navigateToSummaryScreen(List<Customer> customers) {
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
          child: SummaryScreen(
            customer: customers,
          ),
        ),
      ),
    );
  }

  void navigateToMainMenu(Customer customer) {
    CustomerStore.setCustomerId(customer.id);
    CustomerStore.setCustomerName(customer.name);
    BlocProvider.of<DepartmentBloc>(context).add(
      GetDepartmentEvent(
        request: const GetDepartmentRequest(),
      ),
    );
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
          child: MainMenuScreen(customer: customer),
        ),
      ),
    );
  }
}
