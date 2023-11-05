import 'package:flowerstore/data/datasource/invoice/model/request/get_invoice_request.dart';
import 'package:flowerstore/domain/entity/invoice.dart';
import 'package:flowerstore/presentation/bloc/analytic/analytic_bloc.dart';
import 'package:flowerstore/presentation/screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  DateTime? startDate;
  DateTime? endDate;
  List<Invoice> filteredInvoices = [];

  @override
  void initState() {
    super.initState();
    startDate = DateTime(DateTime.now().year, DateTime.now().month, 1);
    endDate = DateTime.now();
    BlocProvider.of<AnalyticBloc>(context)
        .add(GetAnalyticsEvent(request: GetInvoiceRequest()));
  }

  void _calculateTotals(List<Invoice> invoices) {
    if (startDate != null && endDate != null) {
      filteredInvoices = [];

      filteredInvoices = invoices.where(
        (invoice) {
          return invoice.date.isAfter(
                startDate!.subtract(
                  const Duration(days: 1),
                ),
              ) &&
              invoice.date.isBefore(
                endDate!.add(
                  const Duration(days: 1),
                ),
              );
        },
      ).toList();
    } else {
      filteredInvoices = invoices;
    }
    setState(() {});
  }

  Map<int, double> calculateCompanyTotals(List<Invoice> invoices) {
    final Map<int, double> companyTotals = {};

    for (final invoice in invoices) {
      final total = double.parse(invoice.total);

      if (companyTotals.containsKey(invoice.customerId)) {
        double? ivdTotal = companyTotals[invoice.customerId];
        if (ivdTotal == null) {
          companyTotals[invoice.customerId] = total;
        } else {
          companyTotals[invoice.customerId] = total + ivdTotal;
        }
      } else {
        companyTotals[invoice.customerId] = total;
      }
    }

    return companyTotals;
  }

  Map<String, double> calculateCompanyTotalsStringKey(List<Invoice> invoices) {
    final Map<String, double> companyTotals = {};

    for (final invoice in invoices) {
      final total = double.parse(invoice.total);
      final name = widget.customer.firstWhere((element) => element.id == invoice.customerId).name;

      if (companyTotals.containsKey(name)) {
        double? ivdTotal = companyTotals[name];
        if (ivdTotal == null) {
          companyTotals[name] = total;
        } else {
          companyTotals[name] = total + ivdTotal;
        }
      } else {
        companyTotals[name] = total;
      }
    }

    return companyTotals;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('สรุปผลรวมทั้งหมด')),
      body: BlocConsumer<AnalyticBloc, AnalyticState>(
        builder: (context, state) {
          if (state is AnalyticLoaded) {
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
                          startDate = start;
                          endDate = end;
                        });
                        _calculateTotals(state.invoices);
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        Expanded(
                          child: InvoiceSummary(
                            totals: calculateCompanyTotalsStringKey(filteredInvoices),
                          ),
                        ),
                        Expanded(
                          child: BarChartSummary(
                            totals: calculateCompanyTotalsStringKey(filteredInvoices),
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
        listener: (context, state) {
          if (state is AnalyticLoaded) {
            _calculateTotals(state.invoices);
          }
        },
      ),
    );
  }
}
