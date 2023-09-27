class PatchProduct {
  int id;
  String name;
  String unit;
  double price;

  PatchProduct({
    required this.id,
    required this.name,
    required this.unit,
    required this.price,

  });

  factory PatchProduct.fromJson(Map<String, dynamic> json) {
    return PatchProduct(
      id: json['id'],
      name: json['name'],
      unit: json['unit'],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'unit': name,
      'price': name,
    };
  }
}
