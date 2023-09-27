class PatchInvoice {
  String? date;
  double? total;
  int? customerId;

  PatchInvoice({
    this.date,
     this.total,
     this.customerId,
  });

  factory PatchInvoice.fromJson(Map<String, dynamic> json) {
    return PatchInvoice(
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
