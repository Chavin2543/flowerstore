import 'package:intl/intl.dart';

class Invoice {
  int id;
  DateTime date;
  String total;
  int customerId;

  Invoice({
    required this.id,
    required this.date,
    required this.total,
    required this.customerId,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    var format = DateFormat("dd-MM-yyyy");
    DateTime date = format.parse(json['date']);

    return Invoice(
      id: json['id'],
      total: json['total'],
      date: date,
      customerId: json['customer_id'],
    );
  }
}


class InvoiceResponse {
  int statusCode;
  String message;
  List<Invoice> products;

  InvoiceResponse({
    required this.statusCode,
    required this.message,
    required this.products,
  });

  factory InvoiceResponse.fromJson(Map<String, dynamic> json) {
    final productsData = json['Invoices'] as List<dynamic>;
    List<Invoice> productsList = productsData
        .map<Invoice>((json) => Invoice.fromJson(json))
        .toList();

    return InvoiceResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      products: productsList,
    );
  }
}
