import 'package:flowerstore/presentation/screen/analytic/analytic_screen_viewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../base/ui/picker/month_picker.dart';
import '../../../data/datasource/invoice/model/request/get_invoice_request.dart';
import '../../../domain/entity/invoice.dart';
import '../../../helper/customer_store.dart';
import '../../bloc/invoice/invoice_bloc.dart';
import '../../widget/item/month_summary_list_item.dart';
import '../../widget/section/bar_chart_summary.dart';

class AnalyticScreen extends StatefulWidget {
  const AnalyticScreen({super.key});

  @override
  AnalyticScreenState createState() => AnalyticScreenState();
}

class AnalyticScreenState extends State<AnalyticScreen> {
  int startYear = DateTime.now().year;
  int startMonth = 1;
  int endYear = DateTime.now().year;
  int endMonth = DateTime.now().month;

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
      appBar: AppBar(
          title: Text(CustomerStore.getCustomerName() ?? "โรงแรมไม่มีชื่อ")),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          if (state is InvoiceLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  buildMonthPicker(),
                  buildSummaryList(state.invoices),
                ],
              ),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }

  void onMonthRangePicked(int sYear, int sMonth, int eYear, int eMonth) {
    setState(() {
      startYear = sYear;
      startMonth = sMonth;
      endYear = eYear;
      endMonth = eMonth;
    });
  }

}

extension AnalyticScreenBuilder on AnalyticScreenState {
  Widget buildMonthPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: MonthPickerButton(
          onMonthYearRangePicked: (sYear, sMonth, eYear, eMonth) {
            onMonthRangePicked(sYear, sMonth, eYear, eMonth);
          }),
    );
  }

  Widget buildSummaryList(List<Invoice> invoices) {
    Map<DateTime, double> totals = aggregateTotalsByMonth(invoices);
    double totalWithinRange = calculateTotalWithinRange(
      invoices,
      startYear,
      startMonth,
      endYear,
      endMonth,
    );

    return Expanded(
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'ยอดรวมจาก $startMonth/$startYear ถึง $endMonth/$endYear: $totalWithinRange บาท',
                style: Theme.of(context).textTheme.displayLarge,
                textAlign: TextAlign.left,
              )
            ],
          ),
          Expanded(
            child: MonthSummaryListItem(
              totals: totals,
            ),
          ),
          Expanded(
            child: BarChartSummary(
              totals: totals,
            ),
          ),
        ],
      ),
    );
  }
}