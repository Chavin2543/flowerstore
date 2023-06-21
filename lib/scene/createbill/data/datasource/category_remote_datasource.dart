import 'package:dio/dio.dart';
import 'package:flowerstore/scene/createbill/data/model/add_category.dart';
import 'package:flowerstore/scene/createbill/data/model/category.dart';
import 'package:flowerstore/scene/createbill/data/model/patch_category.dart';

abstract class CategoryRemoteDataSource {
  Future<List<Category>> getCategories();

  Future<List<Category>> postCategories(AddCategory request);

  Future<List<Category>> patchCategories(int id, PatchCategory request);

  Future<List<Category>> deleteCategories(int id);
}

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  final Dio dio;

  CategoryRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await dio.get('categories');

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final productsData = jsonResponse['Categories'] as List<dynamic>;

        return productsData
            .map<Category>((json) => Category.fromJson(json))
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
  Future<List<Category>> deleteCategories(int id) async {
    try {
      final response = await dio.delete(
        'categories/$id',
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

    return await getCategories();
  }

  @override
  Future<List<Category>> postCategories(AddCategory request) async {
    try {
      await dio.post(
        'categories',
        data: request.toJson(),
        options: Options(
          contentType: 'application/json',
        ),
      );
    } catch (error) {
      print('Error: $error');
    }

    return await getCategories();
  }

  @override
  Future<List<Category>> patchCategories(int id, PatchCategory request) async {
    try {
      final response = await dio.patch(
        'categories/$id',
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

    return await getCategories();
  }
}
