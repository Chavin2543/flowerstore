class AddProduct {
  String name;

  AddProduct({
    required this.name,
  });

  factory AddProduct.fromJson(Map<String, dynamic> json) {
    return AddProduct(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
