import 'dart:io';

import 'package:flowerstore/data/datasource/invoice/model/request/get_invoice_request.dart';
import 'package:flowerstore/domain/entity/bill_item.dart';
import 'package:flowerstore/presentation/bloc/invoice/invoice_bloc.dart';
import 'package:flowerstore/presentation/screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../../../domain/entity/customer.dart';

class PrintScreen extends StatefulWidget {
  Customer customer;
  String department;
  String company;
  List<BillItem> billItems;
  int invoiceId;
  double discountTotal;
  double discount;

  PrintScreen({
    required this.billItems,
    required this.customer,
    required this.department,
    required this.company,
    required this.invoiceId,
    required this.discount,
    required this.discountTotal,
    Key? key,
  }) : super(key: key);

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  pw.Document? pdfDocument;
  pw.Font? customFont;
  String formattedDate = DateFormat('d MMMM y', 'th').format(DateTime.now());
  int startIndex = 0;
  int pageIndex = 0;
  int totalPages = 0;
  static const double inch = 72.0;
  static const double cm = inch / 2.54;

  @override
  void initState() {
    super.initState();
    _loadFont();
    pdfDocument = pw.Document();
    BlocProvider.of<InvoiceBloc>(context).add(
        GetInvoicesEvent(request: GetInvoiceRequest(), shouldFilter: false));
  }

  @override
  Widget build(BuildContext context) {
    totalPages = (widget.billItems.length / 23).ceil();
    return Scaffold(
      appBar: AppBar(
        title: const Text('พิมพ์ใบเสร็จ'),
      ),
      body: FutureBuilder<Uint8List>(
        future: _loadImageAsset(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const LoadingScreen();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else if (snapshot.hasData) {
            return Column(
              children: [
                Expanded(
                  child: FutureBuilder<pw.Document>(
                    future: _buildPdf(snapshot.data!),
                    builder: (context, pdfSnapshot) {
                      if (pdfSnapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const LoadingScreen();
                      } else if (pdfSnapshot.hasError) {
                        return Text('PDF Error: ${pdfSnapshot.error}');
                      } else if (pdfSnapshot.hasData) {
                        return PdfPreview(
                          canChangePageFormat: false,
                          canChangeOrientation: false,
                          padding: const EdgeInsets.all(0),
                          pageFormats: const {
                            'ใบเสร็จ': PdfPageFormat(8 * inch, 11 * inch,
                                marginAll: 0 * inch),
                          },
                          build: (format) async =>
                              await pdfSnapshot.data!.save(),
                        );
                      } else {
                        return const Text('Unexpected PDF state');
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            return const Text('Unexpected state');
          }
        },
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: pageIndex > 0
                  ? () {
                      setState(() {
                        pageIndex--;
                      });
                    }
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward),
              onPressed: pageIndex + 1 < totalPages
                  ? () {
                      setState(() {
                        pageIndex++;
                      });
                    }
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadFont() async {
    final ByteData data = await rootBundle.load(
      "assets/fonts/CORDIA.ttf",
    );
    final Uint8List fontBytes = data.buffer.asUint8List();
    final loadedFont = pw.Font.ttf(fontBytes.buffer.asByteData());
    setState(() {
      customFont = loadedFont;
    });
  }

  Future<Uint8List> _loadImageAsset() async {
    final ByteData data = await rootBundle.load(
      'assets/templates/bill-template.png',
    );
    final buffer = data.buffer.asUint8List();
    return buffer;
  }

  Future<pw.Document> _buildPdf(Uint8List imageBytes) async {
    final pw.Document doc = pw.Document();
    doc.addPage(
      pw.Page(
        clip: true,
        pageFormat: const PdfPageFormat(8.5 * inch, 11 * inch,
            marginLeft: 0.8 * cm,
            marginRight: 0.8 * cm,
            marginBottom: 0,
            marginTop: 0),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              // pw.Image(
              //   pw.MemoryImage(imageBytes),
              // ),
              pw.Positioned(
                child: pw.Container(
                    child: pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxWidth: 50,
                    maxHeight: 40,
                  ),
                  child: pw.Text(
                    "บิลหมายเลข ${widget.invoiceId} หน้าที่ ${pageIndex + 1}/$totalPages ${widget.customer.name}",
                    style: pw.TextStyle(fontSize: 14, font: customFont),
                  ),
                )),
                top: 1.5 * cm,
                left: 17.6 * cm,
              ),
              pw.Positioned(
                child: pw.Container(
                    child: pw.ConstrainedBox(
                        constraints: const pw.BoxConstraints(
                          maxWidth: 4.25 * inch,
                          maxHeight: 100,
                        ),
                        child: pw.Column(
                          children: [
                            pw.ConstrainedBox(
                              constraints: const pw.BoxConstraints(
                                minWidth: 4.25 * inch,
                                maxWidth: 4.25 * inch,
                                maxHeight: 30,
                              ),
                              child:  pw.Text(
                                widget.customer.name,
                                style:
                                pw.TextStyle(fontSize: 18, font: customFont),
                                textAlign: pw.TextAlign.left,
                              ),
                            ),
                            pw.ConstrainedBox(
                              constraints: const pw.BoxConstraints(
                                minWidth: 4.25 * inch,
                                maxWidth: 4.25 * inch,
                                maxHeight: 30,
                              ),
                              child:   pw.Text(
                                widget.customer.address,
                                style:
                                pw.TextStyle(fontSize: 14, font: customFont),
                                textAlign: pw.TextAlign.left,
                              ),
                            ),
                          ],
                        ))),
                top: 4.75 * cm,
                left: 1.7 * cm,
              ),
              pw.Positioned(
                child: pw.Container(
                    child: pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxWidth: 2.3 * inch,
                    maxHeight: 10,
                  ),
                  child: pw.Text(
                    widget.department,
                    style: pw.TextStyle(fontSize: 14, font: customFont),
                  ),
                )),
                top: 5.7 * cm,
                left: 14.6 * cm,
              ),
              pw.Positioned(
                child: pw.Container(
                    child: pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxWidth: 130,
                    maxHeight: 10,
                  ),
                  child: pw.Text(
                    formattedDate,
                    style: pw.TextStyle(fontSize: 14, font: customFont),
                  ),
                )),
                top: 6.6 * cm,
                left: 14.6 * cm,
              ),
              if (widget.discount != 0.00)
                pw.Positioned(
                  child: pw.Container(
                      child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                      maxWidth: 4 * cm,
                      minWidth: 4 * cm,
                      maxHeight: 0.6 * cm,
                      minHeight: 0.6 * cm,
                    ),
                    child: pw.Text(
                      "SUBTOTAL : ${widget.billItems.total}",
                      style: pw.TextStyle(fontSize: 12, font: customFont),
                      textAlign: pw.TextAlign.right,
                    ),
                  )),
                  top: 23.8 * cm,
                  left: 15.5 * cm,
                ),
              if (widget.discount != 0.00)
                pw.Positioned(
                  child: pw.Container(
                      child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                      maxWidth: 4 * cm,
                      minWidth: 4 * cm,
                      maxHeight: 0.4 * cm,
                      minHeight: 0.4 * cm,
                    ),
                    child: pw.Text(
                      "DISCOUNT : ${widget.discount}",
                      style: pw.TextStyle(fontSize: 12, font: customFont),
                      textAlign: pw.TextAlign.right,
                    ),
                  )),
                  top: 24.4 * cm,
                  left: 15.5 * cm,
                ),
              pw.Positioned(
                child: pw.Container(
                    child: pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxWidth: 2.6 * cm,
                    minWidth: 2.6 * cm,
                    maxHeight: 0.8 * cm,
                    minHeight: 0.8 * cm,
                  ),
                  child: pw.Text(
                    "${widget.discountTotal}",
                    style: pw.TextStyle(fontSize: 18, font: customFont),
                    textAlign: pw.TextAlign.right,
                  ),
                )),
                top: 25.0 * cm,
                left: 16.9 * cm,
              ),
              ...buildInvoiceItems()
            ],
          );
        },
      ),
    );

    buildInvoiceItems();
    return doc;
  }

  List<pw.Widget> buildInvoiceItems() {
    double topPosition = 8.2 * cm;
    double increment = 0.5 * cm;
    List<pw.Widget> items = [];
    List<BillItem> billItems = [];
    if (widget.billItems.length > 23) {
      if (widget.billItems.length - (pageIndex * 23) > 23) {
        billItems =
            widget.billItems.sublist(pageIndex * 23, (pageIndex + 1) * 23);
      } else {
        billItems =
            widget.billItems.sublist(pageIndex * 23, widget.billItems.length);
      }
    } else {
      billItems = widget.billItems;
    }
    for (var item in billItems) {
      if (topPosition <= 24.5 * cm) {
        items.add(
          pw.Positioned(
            top: topPosition,
            left: 0.4 * cm,
            child: pw.Row(
              children: [
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                      minWidth: 1.7 * cm,
                      maxWidth: 2 * cm,
                      maxHeight: 0.5 * cm,
                      minHeight: 0.5 * cm,
                    ),
                    child: pw.Text(
                      '${item.quantity}',
                      style: pw.TextStyle(fontSize: 14, font: customFont),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
                pw.SizedBox(width: 0.35 * cm),
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                      minWidth: 1.5 * cm,
                      maxWidth: 1.5 * cm,
                      maxHeight: 0.5 * cm,
                      minHeight: 0.5 * cm,
                    ),
                    child: pw.Text(
                      item.product.unit,
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: customFont,
                      ),
                      textAlign: pw.TextAlign.center,
                    ),
                  ),
                ),
                pw.SizedBox(width: 0.35 * cm),
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                      minWidth: 10 * cm,
                      maxWidth: 10 * cm,
                      maxHeight: 0.5 * cm,
                      minHeight: 0.5 * cm,
                    ),
                    child: pw.Text(item.product.name,
                        style: pw.TextStyle(fontSize: 14, font: customFont)),
                  ),
                ),
                pw.SizedBox(width: 0.1 * cm),
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                      minWidth: 2.2 * cm,
                      maxWidth: 2.2 * cm,
                      maxHeight: 0.5 * cm,
                      minHeight: 0.5 * cm,
                    ),
                    child: pw.Text(
                      '${item.product.price}',
                      style: pw.TextStyle(
                        fontSize: 14,
                        font: customFont,
                      ),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ),
                pw.SizedBox(width: 0.6 * cm),
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                      minWidth: 2.4 * cm,
                      maxWidth: 2.6 * cm,
                      maxHeight: 0.5 * cm,
                      minHeight: 0.5 * cm,
                    ),
                    child: pw.Text(
                      '${item.product.price * item.quantity}',
                      style: pw.TextStyle(fontSize: 14, font: customFont),
                      textAlign: pw.TextAlign.right,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
        topPosition += increment; // increment the top position for the next row
      }
    }
    return items;
  }

  Future<void> savePdf() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/my_generated_file.pdf';
    final File file = File(path);

    final bytes = await _loadImageAsset();
    final pw.Document doc = await _buildPdf(bytes);
    final pdfFile = await doc.save();

    await file.writeAsBytes(pdfFile);
  }
}
