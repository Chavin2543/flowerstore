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
