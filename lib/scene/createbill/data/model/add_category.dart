class AddCategory {
  String name;

  AddCategory({
    required this.name,
  });

  factory AddCategory.fromJson(Map<String, dynamic> json) {
    return AddCategory(
      name: json['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
