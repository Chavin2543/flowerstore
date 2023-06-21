class Category {
  int id;
  String name;
  int categoryId;
  String categoryName;
  double price;
  String unit;

  Category({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.price,
    required this.unit,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      price: json['price'].toDouble(),
      unit: json['unit'],
    );
  }
}

class CategoryResponse {
  int statusCode;
  String message;
  List<Category> products;

  CategoryResponse({
    required this.statusCode,
    required this.message,
    required this.products,
  });

  factory CategoryResponse.fromJson(Map<String, dynamic> json) {
    final productsData = json['Categories'] as List<dynamic>;
    List<Category> productsList = productsData
        .map<Category>((json) => Category.fromJson(json))
        .toList();

    return CategoryResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      products: productsList,
    );
  }
}
