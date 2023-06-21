class PatchCategory {
  String name;

  PatchCategory({
    required this.name,
  });

  factory PatchCategory.fromJson(Map<String, dynamic> json) {
    return PatchCategory(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
