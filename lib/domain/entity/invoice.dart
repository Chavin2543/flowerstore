class Invoice {
  int id;
  DateTime date;
  String total;
  int customerId;
  int? invoiceId;

  Invoice({
    required this.id,
    required this.date,
    required this.total,
    required this.customerId,
    required this.invoiceId,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json['date']);

    return Invoice(
      id: json['id'],
      total: json['total'],
      date: date,
      customerId: json['customer_id'],
      invoiceId: json['invoice_id'],
    );
  }
}
