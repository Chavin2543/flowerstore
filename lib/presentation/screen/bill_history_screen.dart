import 'package:flowerstore/data/datasource/invoice/model/request/get_invoice_request.dart';
import 'package:flowerstore/domain/entity/customer.dart';
import 'package:flowerstore/presentation/bloc/analytic/analytic_bloc.dart';
import 'package:flowerstore/presentation/screen/loading_screen.dart';
import 'package:flowerstore/presentation/widget/item/bill_history_item.dart';
import 'package:flowerstore/presentation/screen/createbill_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/category/category_bloc.dart';
import '../bloc/customer/customer_bloc.dart';
import '../bloc/invoice/invoice_bloc.dart';
import '../bloc/product/product_bloc.dart';
import '../widget/item/header_bill_history_item.dart';

class BillHistoryScreen extends StatefulWidget {
  final Customer customer;

  const BillHistoryScreen(this.customer, {Key? key}) : super(key: key);

  @override
  State<BillHistoryScreen> createState() => _BillHistoryScreenState();
}

class _BillHistoryScreenState extends State<BillHistoryScreen> {
  @override
  void initState() {
    super.initState();
    _fetchInvoices();
  }

  void _fetchInvoices() {
    BlocProvider.of<InvoiceBloc>(context)
        .add(GetInvoicesEvent(request: GetInvoiceRequest(), shouldFilter: true));
  }

  void _navigateToCreateBillScreen(int invoiceId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (navigatorContext) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<CustomerBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<ProductBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<CategoryBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<InvoiceBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<AnalyticBloc>(context)),
          ],
          child: CreateBillScreen(widget.customer, invoiceId: invoiceId),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          if (state is InvoiceLoaded) {
            return Stack(
              children: [
                _buildInvoiceList(state),
                const Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: HeaderBillHistoryItem(),
                ),
              ],
            );
          }
          return const LoadingScreen();
        },
      ),
    );
  }

  Widget _buildInvoiceList(InvoiceLoaded state) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 60),
      itemBuilder: (context, position) {
        return BillHistoryItem(state.invoices[position], () {
          _navigateToCreateBillScreen(state.invoices[position].id);
        });
      },
      itemCount: state.invoices.length,
    );
  }
}
