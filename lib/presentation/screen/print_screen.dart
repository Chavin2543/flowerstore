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
import '../../domain/entity/customer.dart';

class PrintScreen extends StatefulWidget {
  Customer customer;
  List<BillItem> billItems;

  PrintScreen({required this.billItems, required this.customer, Key? key}) : super(key: key);

  @override
  State<PrintScreen> createState() => _PrintScreenState();
}

class _PrintScreenState extends State<PrintScreen> {
  pw.Document? pdfDocument;
  pw.Font? customFont;
  String formattedDate = DateFormat('d MMMM y', 'th').format(DateTime.now());

  @override
  void initState() {
    super.initState();
    _loadFont(); // No need for .then() here as setState is now inside _loadFont
    pdfDocument = pw.Document();
  }

  Future<void> _loadFont() async {
    final ByteData data =
    await rootBundle.load("assets/fonts/Kanit-Regular.ttf");
    final Uint8List fontBytes = data.buffer.asUint8List();
    final loadedFont = pw.Font.ttf(fontBytes.buffer.asByteData());

    setState(() {
      customFont = loadedFont;
    });
  }

  Future<Uint8List> _loadImageAsset() async {
    final ByteData data = await rootBundle.load('assets/templates/bill-template.jpeg');
    final buffer = data.buffer.asUint8List();
    return buffer;
  }

  Future<pw.Document> _buildPdf(Uint8List imageBytes) async {
    final pw.Document doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Stack(
            children: [
              pw.Image(pw.MemoryImage(imageBytes)),
              pw.Positioned(
                child: pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxWidth: 50, // Max width for the text
                    maxHeight: 10, // Max height for the text
                  ),
                  child: pw.Text(
                    widget.customer.name,
                    style: pw.TextStyle(fontSize: 8, font: customFont),
                  ),
                ),
                top: 91, // position where you want to start your text or content
                left: 422,
              ),
              pw.Positioned(
                child: pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxWidth: 200, // Max width for the text
                    maxHeight: 50, // Max height for the text
                  ),
                  child: pw.Text(
                    widget.customer.address,
                    style: pw.TextStyle(fontSize: 8, font: customFont),
                  ),
                ),
                top: 168, // position where you want to start your text or content
                left: 60,
              ),
              pw.Positioned(
                child: pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxWidth: 130, // Max width for the text
                    maxHeight: 10, // Maxght for the text
                  ),
                  child: pw.Text(
                    widget.customer.id.toString(),
                    style: pw.TextStyle(fontSize: 8, font: customFont),
                  ),
                ),
                top: 189.5, // position where you want to start your text or content
                left: 355,
              ),
              pw.Positioned(
                child: pw.ConstrainedBox(
                  constraints: const pw.BoxConstraints(
                    maxWidth: 130, // Max width for the text
                    maxHeight: 10, // Max height for the text
                  ),
                  child: pw.Text(
                    formattedDate,
                    style: pw.TextStyle(fontSize: 8, font: customFont),
                  ),
                ),
                top: 207, // position where you want to start your text or content
                left: 355,
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
    // Initial top position
    double topPosition = 250.0;

    // Position increment for each row
    double increment = 35.0;

    // Build invoice items
    List<pw.Widget> items = [];
    for (var item in widget.billItems) {
      // Check if the top position exceeds 580
      if (topPosition <= 580) {
        items.add(
          pw.Positioned(
            top: topPosition,  // calculated top position
            left: 30,  // constant left position
            child: pw.Row(
              children: [
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: pw.BoxConstraints(minWidth: 42, maxWidth: 42, maxHeight: 30, minHeight: 30),
                    child: pw.Text('${item.quantity}', style: pw.TextStyle(fontSize: 8, font: customFont)),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: pw.BoxConstraints(minWidth: 30, maxWidth: 30, maxHeight: 30, minHeight: 30),
                    child: pw.Text('${item.product.unit}', style: pw.TextStyle(fontSize: 8, font: customFont)),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: pw.BoxConstraints(minWidth: 223, maxWidth: 223, maxHeight: 30, minHeight: 30),
                    child: pw.Text('${item.product.name}', style: pw.TextStyle(fontSize: 8, font: customFont)),
                  ),
                ),
                pw.SizedBox(width: 8),
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: pw.BoxConstraints(minWidth: 48, maxWidth: 48, maxHeight: 30, minHeight: 30),
                    child: pw.Text('${item.product.price}', style: pw.TextStyle(fontSize: 8, font: customFont)),
                  ),
                ),
                pw.SizedBox(width: 15),
                pw.Container(
                  child: pw.ConstrainedBox(
                    constraints: pw.BoxConstraints(minWidth: 48, maxWidth: 48, maxHeight: 30, minHeight: 30),
                    child: pw.Text('${item.product.price * item.quantity}', style: pw.TextStyle(fontSize: 8, font: customFont)),
                  ),
                ),
              ],
            ),
          ),
        );
        topPosition += increment;  // increment the top position for the next row
      }
    }
    return items;
  }




// Function to print the PDF
  Future<void> _printPdf() async {
    final bytes = await _loadImageAsset();
    final pw.Document doc = await _buildPdf(bytes);
    final pdfFile = await doc.save();

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => bytes,
      format: PdfPageFormat.a4,
    );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('พิมพ์ใบเสร็จ'),
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
                      if (pdfSnapshot.connectionState == ConnectionState.waiting) {
                        return const LoadingScreen();
                      } else if (pdfSnapshot.hasError) {
                        return Text('PDF Error: ${pdfSnapshot.error}');
                      } else if (pdfSnapshot.hasData) {
                        return PdfPreview(
                          build: (format) async => await pdfSnapshot.data!.save(),
                        );
                      } else {
                        return Text('Unexpected PDF state');
                      }
                    },
                  ),
                ),
              ],
            );
          } else {
            return Text('Unexpected state');
          }
        },
      ),
    );
  }
}