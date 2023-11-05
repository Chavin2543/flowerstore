import 'package:dio/dio.dart';
import 'package:flowerstore/data/datasource/product/model/add_product_request.dart';
import 'package:flowerstore/data/datasource/product/model/delete_product_request.dart';
import 'package:flowerstore/data/datasource/product/model/get_product_by_id_request.dart';
import 'package:flowerstore/data/datasource/product/model/get_product_request.dart';
import 'package:flowerstore/data/datasource/product/model/patch_product_request.dart';
import 'package:flowerstore/domain/entity/product.dart';

import '../../../helper/customer_store.dart';
import '../../../helper/error_manager.dart';
import '../../api_error.dart';

abstract class ProductDatasource {
  Future<List<Product>> getProduct(GetProductRequest request);
  Future<List<Product>> addProduct(AddProductRequest request);
  Future<List<Product>> patchProduct(PatchProductRequest request);
  Future<List<Product>> deleteProduct(DeleteProductRequest request);
  Future<Product?> getProductById(GetProductByIdRequest request);
}

class ProductDatasourceImpl implements ProductDatasource {
  final Dio dio;

  ProductDatasourceImpl(this.dio);

  @override
  Future<List<Product>> getProduct(GetProductRequest request) async {
    try {
      final response = await dio.get('products');

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final customersData = jsonResponse['Products'] as List<dynamic>;
        return customersData
            .map<Product>((json) => Product.fromJson(json))
            .toList();
      } else {
        throw APIError(
            'API request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }
  }

  @override
  Future<List<Product>> deleteProduct(DeleteProductRequest request) async {
    try {
      final response = await dio.delete(
        'products/${request.id}',
        options: Options(
          contentType: 'application/json',
        ),
      );

      if (response.statusCode != 200) {
        throw APIError(
            'DELETE request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await refreshProduct();
  }

  @override
  Future<List<Product>> addProduct(AddProductRequest request) async {
    try {
      await dio.post(
        'products',
        data: request.toJson(),
        options: Options(
          contentType: 'application/json',
        ),
      );
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await refreshProduct();
  }

  @override
  Future<List<Product>> patchProduct(PatchProductRequest request) async {
    try {
      final response = await dio.patch(
        'products/${request.id}',
        data: request.toJson(),
        options: Options(
          contentType: 'application/json',
        ),
      );

      if (response.statusCode != 200) {
        throw APIError(
            'PATCH request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await refreshProduct();
  }

  @override
  Future<Product?> getProductById(GetProductByIdRequest request) async {
    try {
      final response = await dio.get('products/${request.id}');

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final productData = jsonResponse['product'];

        return Product.fromJson(productData);
      } else {
        throw APIError(
            'API request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }
  }

  Future<List<Product>> refreshProduct() async {
    return await getProduct(GetProductRequest());
  }
}
