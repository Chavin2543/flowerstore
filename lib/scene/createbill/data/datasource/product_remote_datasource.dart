import 'package:dio/dio.dart';
import 'package:flowerstore/scene/createbill/data/model/add_product.dart';
import 'package:flowerstore/scene/createbill/data/model/patch_product.dart';
import 'package:flowerstore/scene/createbill/data/model/product.dart';

abstract class ProductRemoteDataSource {
  Future<List<Product>> getProducts();

  Future<List<Product>> postProducts(AddProduct request);

  Future<List<Product>> patchProducts(int id, PatchProduct request);

  Future<List<Product>> deleteProducts(int id);
}

class ProductRemoteDataSourceImpl implements ProductRemoteDataSource {
  final Dio dio;

  ProductRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Product>> getProducts() async {
    try {
      final response = await dio.get('products');

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final productsData = jsonResponse['Products'] as List<dynamic>;

        return productsData
            .map<Product>((json) => Product.fromJson(json))
            .toList();
      } else {
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: ${error.toString()}');
    }

    return [];
  }

  @override
  Future<List<Product>> deleteProducts(int id) async {
    try {
      final response = await dio.delete(
        'products/$id',
        options: Options(
          contentType: 'application/json',
        ),
      );

      if (response.statusCode == 200) {
        print('DELETE request successful');
      } else {
        print('DELETE request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return await getProducts();
  }

  @override
  Future<List<Product>> postProducts(AddProduct request) async {
    try {
      await dio.post(
        'products',
        data: request.toJson(),
        options: Options(
          contentType: 'application/json',
        ),
      );
    } catch (error) {
      print('Error: $error');
    }

    return await getProducts();
  }

  @override
  Future<List<Product>> patchProducts(int id, PatchProduct request) async {
    try {
      final response = await dio.patch(
        'products/$id',
        data: request.toJson(),
        options: Options(
          contentType: 'application/json',
        ),
      );

      if (response.statusCode == 200) {
        print('PATCH request successful');
        print('Response: ${response.data}');
      } else {
        print('PATCH request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
    }

    return await getProducts();
  }
}
