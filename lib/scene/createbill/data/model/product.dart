class Product {
  int id;
  String name;
  int categoryId;
  String categoryName;
  double price;
  String unit;

  Product({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.price,
    required this.unit,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      categoryId: json['category_id'],
      categoryName: json['category_name'],
      price: json['price'].toDouble(),
      unit: json['unit'],
    );
  }
}

class ProductsResponse {
  int statusCode;
  String message;
  List<Product> products;

  ProductsResponse({
    required this.statusCode,
    required this.message,
    required this.products,
  });

  factory ProductsResponse.fromJson(Map<String, dynamic> json) {
    final productsData = json['Products'] as List<dynamic>;
    List<Product> productsList = productsData
        .map<Product>((json) => Product.fromJson(json))
        .toList();

    return ProductsResponse(
      statusCode: json['statusCode'],
      message: json['message'],
      products: productsList,
    );
  }
}
