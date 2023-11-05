class InvoiceItem {
  int id;
  int quantity;
  int total_price;
  int invoice_id;
  int product_id;
  int category_id;

  InvoiceItem({
    required this.id,
    required this.quantity,
    required this.total_price,
    required this.invoice_id,
    required this.product_id,
    required this.category_id,
  });

  factory InvoiceItem.fromJson(Map<String, dynamic> json) {
    return InvoiceItem(
      id: json['id'],
      quantity: json['quantity'],
      total_price: json['total_price'],
      invoice_id: json['invoice_id'],
      product_id: json['product_id'],
      category_id: json['category_id'],
    );
  }
}
