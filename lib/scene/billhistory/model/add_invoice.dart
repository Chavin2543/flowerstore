class AddInvoice {
  String date;
  double total;
  int customerId;

  AddInvoice({
    required this.date,
    required this.total,
    required this.customerId,
  });

  factory AddInvoice.fromJson(Map<String, dynamic> json) {
    return AddInvoice(
        date: json['date'],
        total: json['double'],
        customerId: json['customer_id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'total': total,
      'customer_id': customerId,
    };
  }
}
