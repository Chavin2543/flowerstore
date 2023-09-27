class AddProduct {
  String name;
  double price;
  String unit;
  int customerId;
  int? categoryId;

  AddProduct({
    required this.name,
    required this.price,
    required this.unit,
    required this.customerId,
    this.categoryId,
  });

  factory AddProduct.fromJson(Map<String, dynamic> json) {
    return AddProduct(
      name: json['name'],
      price: json['price'],
      unit: json['unit'],
      customerId: json['customer_id'],
      categoryId: json['category_id'],
    );
  }

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
