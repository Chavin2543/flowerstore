class Invoice {
  int id;
  int departmentId;
  int customerId;
  int invoiceId;
  DateTime date;
  double total;
  double discount;
  double discountedTotal;
  String biller;

  Invoice({
    required this.id,
    required this.date,
    required this.total,
    required this.customerId,
    required this.invoiceId,
    required this.discount,
    required this.discountedTotal,
    required this.biller,
    required this.departmentId,
  });

  factory Invoice.fromJson(Map<String, dynamic> json) {
    DateTime date = DateTime.parse(json['date']);

    return Invoice(
      id: json['id'],
      total: _toDouble(json['total']),
      date: date,
      customerId: json['customer_id'],
      invoiceId: json['invoice_id'],
      discountedTotal: _toDouble(json['discounted_total']),
      discount: _toDouble(json['discount']),
      biller: json['biller'],
      departmentId: json['department_id'],
    );
  }

  static double _toDouble(dynamic value) {
    return (value as num).toDouble();
  }
}
