class Product {
  int id;
  String name;
  int categoryId;
  double price;
  String unit;
  int customerId;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.customerId,
    required this.price,
    required this.unit,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      customerId: json['customer_id'],
      price: json['price'].toDouble(),
      unit: json['unit'],
    );
  }

  Product copyWith({
    int? id,
    String? name,
    int? categoryId,
    double? price,
    String? unit,
    int? customerId
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      categoryId: categoryId ?? this.categoryId,
      price: price ?? this.price,
      unit: unit ?? this.unit,
      customerId: customerId ?? this.customerId
    );
  }
}