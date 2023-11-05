class AddInvoiceItemRequest {
  int quantity;
  double totalPrice;
  int invoiceId;
  int productId;
  int categoryId;

  AddInvoiceItemRequest({
    required this.quantity,
    required this.totalPrice,
    required this.invoiceId,
    required this.productId,
    required this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
      'total_price': totalPrice,
      'invoice_id': invoiceId,
      'product_id': productId,
      'category_id': categoryId,
    };
  }
}