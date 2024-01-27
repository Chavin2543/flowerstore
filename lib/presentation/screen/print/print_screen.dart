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
  int department;
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
      "assets/fonts/Kanit-Regular.ttf",
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
        pageFormat: const PdfPageFormat(
            576,
            792,
            marginAll: 0
        ),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Positioned(
                child: pw.Container(
                    color: PdfColor.fromHex("#B2BEB5"),
                    child: pw.ConstrainedBox(
                      constraints: const pw.BoxConstraints(
                        maxWidth: 50,
                        maxHeight: 10,
                      ),
                      child: pw.Text(
                        "บิลหมายเลข ${widget.invoiceId} หน้าที่ ${pageIndex + 1}/$totalPages ${widget.customer.name}",
                        style: pw.TextStyle(fontSize: 8, font: customFont),
                      ),
                    )),
                top: 18,
                right: 0
              ),
              pw.Positioned(
                child: pw.Container(
                    color: PdfColor.fromHex("#B2BEB5"),
                    child: pw.ConstrainedBox(
                      constraints: const pw.BoxConstraints(
                        maxWidth: 200,
                        maxHeight: 50,
                      ),
                      child: pw.Text(
                        "แผนก ${widget.department}, ${widget.customer.address}",
                        style: pw.TextStyle(fontSize: 8, font: customFont),
                      ),
                    )),
                top: 92,
                left: 31,
              ),
              pw.Positioned(
                child: pw.Container(
                    color: PdfColor.fromHex("#B2BEB5"),
                    child: pw.ConstrainedBox(
                      constraints: const pw.BoxConstraints(
                        maxWidth: 130,
                        maxHeight: 10,
                      ),
                      child: pw.Text(
                        widget.customer.id.toString(),
                        style: pw.TextStyle(fontSize: 8, font: customFont),
                      ),
                    )),
                top: 158.4,
                right: 158.4,
              ),
              pw.Positioned(
                child: pw.Container(
                    color: PdfColor.fromHex("#B2BEB5"),
                    child: pw.ConstrainedBox(
                      constraints: const pw.BoxConstraints(
                        maxWidth: 130,
                        maxHeight: 10,
                      ),
                      child: pw.Text(
                        formattedDate,
                        style: pw.TextStyle(fontSize: 8, font: customFont),
                      ),
                    )),
                top: 194.4,
                right: 158.4,
              ),
              pw.Positioned(
                child: pw.Container(
                    color: PdfColor.fromHex("#B2BEB5"),
                    child: pw.ConstrainedBox(
                      constraints: const pw.BoxConstraints(
                        maxWidth: 130,
                        maxHeight: 10,
                      ),
                      child: pw.Text(
                        "SUBTOTAL : ${widget.billItems.total} บาท",
                        style: pw.TextStyle(fontSize: 8, font: customFont),
                      ),
                    )),
                top: 610,
                right: 0,
              ),
              pw.Positioned(
                child: pw.Container(
                    color: PdfColor.fromHex("#B2BEB5"),
                    child: pw.ConstrainedBox(
                      constraints: const pw.BoxConstraints(
                        maxWidth: 130,
                        maxHeight: 10,
                      ),
                      child: pw.Text(
                        "DISCOUNT : ${widget.discount} บาท",
                        style: pw.TextStyle(fontSize: 8, font: customFont),
                      ),
                    )),
                top: 630,
                right: 0,
              ),
              pw.Positioned(
                child: pw.Container(
                    color: PdfColor.fromHex("#B2BEB5"),
                    child: pw.ConstrainedBox(
                      constraints: const pw.BoxConstraints(
                        maxWidth: 130,
                        maxHeight: 10,
                      ),
                      child: pw.Text(
                        "${widget.discountTotal} บาท",
                        style: pw.TextStyle(fontSize: 8, font: customFont),
                      ),
                    )),
                top: 650,
                right: 0,
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
    double topPosition = 200.0;
    double increment = 20.0;
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
      if (topPosition <= 700) {
        items.add(
          pw.Positioned(
            top: topPosition, // calculated top position
            left: 10, // constant left position
            child: pw.Row(
              children: [
                pw.Container(
                  color: PdfColor.fromHex("#B2BEB5"),
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                      minWidth: 40,
                      maxWidth: 40,
                      maxHeight: 40,
                      minHeight: 40,
                    ),
                    child: pw.Text('${item.quantity}',
                        style: pw.TextStyle(fontSize: 8, font: customFont)),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Container(
                  color: PdfColor.fromHex("#B2BEB5"),
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                      minWidth: 40,
                      maxWidth: 40,
                      maxHeight: 40,
                      minHeight: 40,
                    ),
                    child: pw.Text(item.product.unit,
                        style: pw.TextStyle(
                          fontSize: 8,
                          font: customFont,
                        )),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Container(
                  color: PdfColor.fromHex("#B2BEB5"),
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                      minWidth: 233,
                      maxWidth: 233,
                      maxHeight: 30,
                      minHeight: 30,
                    ),
                    child: pw.Text(item.product.name,
                        style: pw.TextStyle(fontSize: 8, font: customFont)),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Container(
                  color: PdfColor.fromHex("#B2BEB5"),
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                        minWidth: 58,
                        maxWidth: 58,
                        maxHeight: 30,
                        minHeight: 30),
                    child: pw.Text('${item.product.price}',
                        style: pw.TextStyle(fontSize: 8, font: customFont)),
                  ),
                ),
                pw.SizedBox(width: 15),
                pw.Container(
                  color: PdfColor.fromHex("#B2BEB5"),
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                        minWidth: 58,
                        maxWidth: 58,
                        maxHeight: 30,
                        minHeight: 30),
                    child: pw.Text('${item.product.price * item.quantity}',
                        style: pw.TextStyle(fontSize: 8, font: customFont)),
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
