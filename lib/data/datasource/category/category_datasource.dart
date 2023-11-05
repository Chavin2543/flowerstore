import 'package:dio/dio.dart';
import 'package:flowerstore/data/api_error.dart';
import 'package:flowerstore/data/datasource/category/model/request/add_category_request.dart';
import 'package:flowerstore/data/datasource/category/model/request/delete_category_request.dart';
import 'package:flowerstore/data/datasource/category/model/request/get_category_request.dart';
import 'package:flowerstore/data/datasource/category/model/request/patch_category_request.dart';
import 'package:flowerstore/helper/customer_store.dart';
import 'package:flowerstore/helper/error_manager.dart';
import '../../../domain/entity/category.dart';

abstract class CategoryDataSource {
  Future<List<Category>> getCategory(GetCategoryRequest request);
  Future<List<Category>> addCategory(AddCategoryRequest request);
  Future<List<Category>> patchCategory(PatchCategoryRequest request);
  Future<List<Category>> deleteCategory(DeleteCategoryRequest request);
}

class CategoryDataSourceImpl implements CategoryDataSource {
  final Dio dio;

  CategoryDataSourceImpl(this.dio);

  @override
  Future<List<Category>> getCategory(GetCategoryRequest request) async {
    try {
      final response = await dio.get('categories');
      if (response.statusCode! >= 200 && response.statusCode! <= 204) {
        return (response.data['categories'] as List)
            .map<Category>((json) => Category.fromJson(json))
            .toList();
      }

      throw APIError(
          'Failed to fetch categories. Status code: ${response.statusCode}'
      );
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }
  }

  @override
  Future<List<Category>> deleteCategory(DeleteCategoryRequest request) async {
    try {
      final response = await dio.delete(
        'categories/${request.categoryId}',
        options: Options(
          contentType: 'application/json',
        ),
      );

      if (response.statusCode! <= 200 && response.statusCode! >= 204) {
        throw APIError('DELETE request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await refreshCategory();
  }

  @override
  Future<List<Category>> addCategory(AddCategoryRequest request) async {
    try {
      await dio.post(
        'categories',
        data: request.toJson(),
        options: Options(
          contentType: 'application/json',
        ),
      );
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await refreshCategory();
  }

  @override
  Future<List<Category>> patchCategory(PatchCategoryRequest request) async {
    try {
      final response = await dio.patch(
        'categories/${request.categoryId}',
        data: request.toJson(),
        options: Options(
          contentType: 'application/json',
        ),
      );

      if (response.statusCode! <= 200 && response.statusCode! >= 204) {
        throw APIError('PATCH request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await refreshCategory();
  }

  Future<List<Category>> refreshCategory() async {
    return await getCategory(const GetCategoryRequest());
  }
}
