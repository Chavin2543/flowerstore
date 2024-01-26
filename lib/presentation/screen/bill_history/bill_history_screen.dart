import 'package:flowerstore/data/datasource/invoice/model/request/get_invoice_request.dart';
import 'package:flowerstore/domain/entity/customer.dart';
import 'package:flowerstore/presentation/screen/bill_history/bill_history_dialog.dart';
import 'package:flowerstore/presentation/screen/loading_screen.dart';
import 'package:flowerstore/presentation/widget/item/bill_history_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/invoice/invoice_bloc.dart';
import '../../widget/item/header_bill_history_item.dart';

class BillHistoryScreen extends StatefulWidget {
  const BillHistoryScreen(this.customer, {Key? key}) : super(key: key);

  final Customer customer;

  @override
  State<BillHistoryScreen> createState() => BillHistoryScreenState();
}

class BillHistoryScreenState extends State<BillHistoryScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<InvoiceBloc>(context).add(
      GetInvoicesEvent(
        request: GetInvoiceRequest(),
        shouldFilter: true,
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
                buildInvoiceList(state),
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
}

extension BillHistoryBuilder on BillHistoryScreenState {
  Widget buildInvoiceList(InvoiceLoaded state) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 60),
      itemBuilder: (context, position) {
        return BillHistoryItem(
          state.invoices[position],
              () {
            showInvoiceOptionDialog(
              state.invoices[position],
            );
          },
        );
      },
      itemCount: state.invoices.length,
    );
  }
}
