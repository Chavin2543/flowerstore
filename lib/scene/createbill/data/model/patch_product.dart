class PatchProduct {
  String name;

  PatchProduct({
    required this.name,
  });

  factory PatchProduct.fromJson(Map<String, dynamic> json) {
    return PatchProduct(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
