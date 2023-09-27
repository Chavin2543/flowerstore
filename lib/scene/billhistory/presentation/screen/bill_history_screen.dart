import 'package:flowerstore/scene/billhistory/presentation/widget/bill_history_item.dart';
import 'package:flowerstore/scene/dashboard/data/model/customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/invoice_bloc.dart';

class BillHistoryScreen extends StatefulWidget {
  const BillHistoryScreen(this.customer, {Key? key}) : super(key: key);

  final Customer customer;

  @override
  State<BillHistoryScreen> createState() => _BillHistoryScreenState();
}

class _BillHistoryScreenState extends State<BillHistoryScreen> {
  @override
  void initState() {
    BlocProvider.of<InvoiceBloc>(context)
        .add(QueryInvoiceEvent(widget.customer.id));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          if (state is InvoiceLoaded) {
            return LayoutBuilder(
              builder: (context, boxConstraints) {
                return Row(
                  children: [
                    SizedBox(
                      width: boxConstraints.maxWidth,
                      child: ListView.builder(
                        itemBuilder: (context, position) {
                          return BillHistoryItem(state.invoices[position]);
                        },
                        itemCount: state.invoices.length,
                      ),
                    )
                  ],
                );
              },
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }
}
