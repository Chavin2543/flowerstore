import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../base/ui/picker/month_picker.dart';
import '../../data/datasource/invoice/model/request/get_invoice_request.dart';
import '../../domain/entity/invoice.dart';
import '../../helper/customer_store.dart';
import '../bloc/invoice/invoice_bloc.dart';
import '../widget/item/month_summary_list_item.dart';
import '../widget/section/bar_chart_summary.dart';

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

  void _onMonthRangePicked(int sYear, int sMonth, int eYear, int eMonth) {
    setState(() {
      startYear = sYear;
      startMonth = sMonth;
      endYear = eYear;
      endMonth = eMonth;
    });
  }

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
      appBar: AppBar(title: Text(CustomerStore.getCustomerName() ?? "โรงแรมไม่มีชื่อ")),
      body: BlocBuilder<InvoiceBloc, InvoiceState>(
        builder: (context, state) {
          if (state is InvoiceLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMonthPicker(),
                  _buildSummaryList(state.invoices),
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

  Widget _buildMonthPicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: MonthPickerButton(
          onMonthYearRangePicked: (sYear, sMonth, eYear, eMonth) {
        _onMonthRangePicked(sYear, sMonth, eYear, eMonth);
      }),
    );
  }

  Map<DateTime, double> _aggregateTotalsByMonth(List<Invoice> invoices) {
    Map<DateTime, double> monthlyTotals = {};
    for (var invoice in invoices) {
      if ((startYear == null ||
              invoice.date.year > startYear ||
              (invoice.date.year == startYear &&
                  invoice.date.month >= startMonth)) &&
          (endYear == null ||
              invoice.date.year < endYear ||
              (invoice.date.year == endYear &&
                  invoice.date.month <= endMonth))) {
        DateTime monthKey = DateTime(invoice.date.year, invoice.date.month);
        double total = double.tryParse(invoice.total) ?? 0;

        if (monthlyTotals.containsKey(monthKey)) {
          monthlyTotals[monthKey] = monthlyTotals[monthKey]! + total;
        } else {
          monthlyTotals[monthKey] = total;
        }
      }
    }
    return monthlyTotals;
  }

  double _calculateYearlyTotal(List<Invoice> invoices) {
    int currentYear = DateTime.now().year;
    double yearlyTotal = 0.0;

    for (var invoice in invoices) {
      if (invoice.date.year == currentYear) {
        yearlyTotal += double.tryParse(invoice.total) ?? 0.0;
      }
    }
    return yearlyTotal;
  }

  double _calculateTotalWithinRange(List<Invoice> invoices, int startYear,
      int startMonth, int endYear, int endMonth) {
    double total = 0.0;

    for (var invoice in invoices) {
      if ((invoice.date.year > startYear ||
              (invoice.date.year == startYear &&
                  invoice.date.month >= startMonth)) &&
          (invoice.date.year < endYear ||
              (invoice.date.year == endYear &&
                  invoice.date.month <= endMonth))) {
        total += double.tryParse(invoice.total) ?? 0.0;
      }
    }
    return total;
  }

  Widget _buildSummaryList(List<Invoice> invoices) {
    Map<DateTime, double> totals = _aggregateTotalsByMonth(invoices);
    double totalWithinRange = _calculateTotalWithinRange(
        invoices, startYear, startMonth, endYear, endMonth);

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
