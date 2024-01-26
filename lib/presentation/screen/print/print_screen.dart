import 'package:flowerstore/domain/entity/bill_item.dart';
import 'package:flowerstore/presentation/screen/loading_screen.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'dart:io';
import '../../../domain/entity/customer.dart';

class PrintScreen extends StatefulWidget {
  Customer customer;
  int department;
  String company;
  List<BillItem> billItems;

  PrintScreen({
    required this.billItems,
    required this.customer,
    required this.department,
    required this.company,
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
        pageFormat: PdfPageFormat.a4.applyMargin(left: 0, top: 0, right: 0, bottom: 0),
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Image(
                pw.MemoryImage(imageBytes),
              ),
              pw.Positioned(
                child: pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxWidth: 50,
                    maxHeight: 10,
                  ),
                  child: pw.Text(
                    "${pageIndex + 1}/$totalPages ${widget.customer.name}",
                    style: pw.TextStyle(fontSize: 8, font: customFont),
                  ),
                ),
                top: 38,
                left: 410,
              ),
              pw.Positioned(
                child: pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxWidth: 200,
                    maxHeight: 50,
                  ),
                  child: pw.Text(
                    "แผนก ${widget.department}, ${widget.customer.address}",
                    style: pw.TextStyle(fontSize: 8, font: customFont),
                  ),
                ),
                top: 112,
                left: 51,
              ),
              pw.Positioned(
                child: pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxWidth: 130,
                    maxHeight: 10,
                  ),
                  child: pw.Text(
                    widget.customer.id.toString(),
                    style: pw.TextStyle(fontSize: 8, font: customFont),
                  ),
                ),
                top: 137,
                left: 350,
              ),
              pw.Positioned(
                child: pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxWidth: 130,
                    maxHeight: 10,
                  ),
                  child: pw.Text(
                    formattedDate,
                    style: pw.TextStyle(fontSize: 8, font: customFont),
                  ),
                ),
                top: 155,
                left: 350,
              ),
              pw.Positioned(
                child: pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxWidth: 130,
                    maxHeight: 10,
                  ),
                  child: pw.Text(
                    "${widget.billItems.total} บาท",
                    style: pw.TextStyle(fontSize: 8, font: customFont),
                  ),
                ),
                top: 582,
                left: 395,
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
            left: 30, // constant left position
            child: pw.Row(
              children: [
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                        minWidth: 42,
                        maxWidth: 42,
                        maxHeight: 30,
                        minHeight: 30),
                    child: pw.Text('${item.quantity}',
                        style: pw.TextStyle(fontSize: 8, font: customFont)),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                        minWidth: 30,
                        maxWidth: 30,
                        maxHeight: 30,
                        minHeight: 30),
                    child: pw.Text(item.product.unit,
                        style: pw.TextStyle(fontSize: 8, font: customFont)),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                        minWidth: 223,
                        maxWidth: 223,
                        maxHeight: 30,
                        minHeight: 30),
                    child: pw.Text(item.product.name,
                        style: pw.TextStyle(fontSize: 8, font: customFont)),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                        minWidth: 48,
                        maxWidth: 48,
                        maxHeight: 30,
                        minHeight: 30),
                    child: pw.Text('${item.product.price}',
                        style: pw.TextStyle(fontSize: 8, font: customFont)),
                  ),
                ),
                pw.SizedBox(width: 15),
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: const pw.BoxConstraints(
                        minWidth: 48,
                        maxWidth: 48,
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
    print("PDF saved at $path");
  }
}
