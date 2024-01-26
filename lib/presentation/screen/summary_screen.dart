import 'package:flowerstore/data/datasource/invoice/model/request/get_invoice_request.dart';
import 'package:flowerstore/domain/entity/invoice.dart';
import 'package:flowerstore/presentation/bloc/analytic/analytic_bloc.dart';
import 'package:flowerstore/presentation/screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../domain/entity/customer.dart';
import '../widget/button/date_picker_button.dart';
import '../widget/section/bar_chart_summary.dart';
import '../widget/section/invoice_summary.dart';

class SummaryScreen extends StatefulWidget {
  final List<Customer> customer;

  const SummaryScreen({super.key, required this.customer});

  @override
  SummaryScreenState createState() => SummaryScreenState();
}

class SummaryScreenState extends State<SummaryScreen> {
  DateTime startDate = DateTime(DateTime.now().year, 1, 1);
  DateTime endDate = DateTime.now();
  List<Invoice> filteredInvoices = [];

  @override
  void initState() {
    super.initState();
    startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    endDate = DateTime.now();
    BlocProvider.of<AnalyticBloc>(context)
        .add(GetAnalyticsEvent(request: GetInvoiceRequest()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('สรุปผลรวมทั้งหมด')),
      body: BlocConsumer<AnalyticBloc, AnalyticState>(
        builder: (context, state) {
          if (state is AnalyticLoaded) {
            _calculateTotals(state.invoices);
            double totalWithinRange = _calculateTotalWithinRange(filteredInvoices);
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: DateRangePickerButton(
                      onDateRangePicked: (DateTime? start, DateTime? end) {
                        setState(() {
                          startDate = start ?? DateTime(DateTime.now().year, 1, 1);
                          endDate = end ?? DateTime.now();
                        });
                        _calculateTotals(state.invoices);
                      },
                    ),
                  ),
                  Text(
                    'ยอดรวมในระหว่าง ${formatDateTimeToThaiDate(startDate)} ถึง ${formatDateTimeToThaiDate(endDate)} : $totalWithinRange บาท',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.3,
                          child: InvoiceSummary(
                            totals: calculateCompanyTotalsStringKey(filteredInvoices),
                          ),
                        ),
                        Expanded(
                          child: BarChartSummary(
                            totals: _aggregateTotalsByMonth(filteredInvoices),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else {
            return const LoadingScreen();
          }
        },
        listener: (context, state) {},
      ),
    );
  }
}

extension SummaryScreenCalculations on SummaryScreenState {
  void _calculateTotals(List<Invoice> invoices) {
    filteredInvoices = invoices.where((invoice) {
      return invoice.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          invoice.date.isBefore(endDate.add(const Duration(days: 1)));
    }).toList();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      setState(() {});
    });
  }

  Map<String, double> calculateCompanyTotalsStringKey(List<Invoice> invoices) {
    final Map<String, double> companyTotals = {};
    for (final invoice in invoices) {
      final total = invoice.discountedTotal;
      final customer = widget.customer.firstWhere(
              (element) => element.id == invoice.customerId,
          orElse: () => Customer(id: -1, name: 'Unknown', phone: '', address: '')
      );
      final name = customer.name;
      if (companyTotals.containsKey(name)) {
        companyTotals[name] = companyTotals[name]! + total;
      } else {
        companyTotals[name] = total;
      }
    }
    return companyTotals;
  }

  double _calculateTotalWithinRange(List<Invoice> invoices) {
    double total = 0.0;
    for (var invoice in invoices) {
      total += invoice.discountedTotal;
    }
    return total;
  }

  Map<DateTime, double> _aggregateTotalsByMonth(List<Invoice> invoices) {
    Map<DateTime, double> monthlyTotals = {};
    for (var invoice in invoices) {
      if (invoice.date.isAfter(startDate.subtract(const Duration(days: 1))) &&
          invoice.date.isBefore(endDate.add(const Duration(days: 1)))) {
        DateTime monthKey = DateTime(invoice.date.year, invoice.date.month);
        double total = invoice.discountedTotal;
        monthlyTotals.update(monthKey, (existingTotal) => existingTotal + total, ifAbsent: () => total);
      }
    }
    return monthlyTotals;
  }


  String formatDateTimeToThaiDate(DateTime dateTime) {
    String formattedDate = DateFormat('d MMM yy', 'th').format(dateTime);
    return formattedDate;
  }
}
