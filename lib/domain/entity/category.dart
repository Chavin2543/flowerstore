class Category {
  int id;
  String name;
  int customerId;

  Category({
    required this.id,
    required this.name,
    required this.customerId,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      customerId: json['customer_id'],
    );
  }
}