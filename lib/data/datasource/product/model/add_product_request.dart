class AddProductRequest {
  String name;
  double price;
  String unit;
  int customerId;
  int? categoryId;

  AddProductRequest({
    required this.name,
    required this.price,
    required this.unit,
    required this.customerId,
    this.categoryId,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'price': price,
      'unit': unit,
      'customer_id': customerId,
      'category_id': categoryId,
    };
  }
}