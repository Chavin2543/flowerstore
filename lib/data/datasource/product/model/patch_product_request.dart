class PatchProductRequest {
  int id;
  int customerId;
  String name;
  String unit;
  double price;

  PatchProductRequest({
    required this.id,
    required this.customerId,
    required this.name,
    required this.unit,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'unit': unit,
      'price': price,
    };
  }
}