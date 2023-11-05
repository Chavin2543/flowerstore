import 'package:dio/dio.dart';
import 'package:flowerstore/data/api_error.dart';
import 'package:flowerstore/data/datasource/department/model/add_department_request.dart';
import 'package:flowerstore/data/datasource/department/model/delete_department_request.dart';
import 'package:flowerstore/data/datasource/department/model/get_department_request.dart';
import 'package:flowerstore/data/datasource/department/model/patch_department_request.dart';
import 'package:flowerstore/helper/error_manager.dart';

abstract class DepartmentDataSource {
  Future<List<String>> getDepartment(GetDepartmentRequest request);
  Future<List<String>> addDepartment(AddDepartmentRequest request);
  Future<List<String>> patchDepartment(PatchDepartmentRequest request);
  Future<List<String>> deleteDepartment(DeleteDepartmentRequest request);
}

class DepartmentDataSourceImpl implements DepartmentDataSource {
  final Dio dio;

  DepartmentDataSourceImpl(this.dio);

  @override
  Future<List<String>> getDepartment(GetDepartmentRequest request) async {
    try {
      final response = await dio.get('departments');
      if (response.statusCode == 200) {
        return (response.data['Departments'] as List<String>)
            .toList();
      }

      throw APIError(
          'Failed to fetch departments. Status code: ${response.statusCode}'
      );
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }
  }

  @override
  Future<List<String>> deleteDepartment(DeleteDepartmentRequest request) async {
    try {
      final response = await dio.delete(
        'departments/${request.departmentId}',
        options: Options(
          contentType: 'application/json',
        ),
      );

      if (response.statusCode != 200) {
        throw APIError('DELETE request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await refreshDepartment();
  }

  @override
  Future<List<String>> addDepartment(AddDepartmentRequest request) async {
    try {
      await dio.post(
        'departments',
        data: request.toJson(),
        options: Options(
          contentType: 'application/json',
        ),
      );
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await refreshDepartment();
  }

  @override
  Future<List<String>> patchDepartment(PatchDepartmentRequest request) async {
    try {
      final response = await dio.patch(
        'departments/${request.departmentId}',
        data: request.toJson(),
        options: Options(
          contentType: 'application/json',
        ),
      );

      if (response.statusCode != 200) {
        throw APIError('PATCH request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await refreshDepartment();
  }

  Future<List<String>> refreshDepartment() async {
    return await getDepartment(const GetDepartmentRequest());
  }
}
