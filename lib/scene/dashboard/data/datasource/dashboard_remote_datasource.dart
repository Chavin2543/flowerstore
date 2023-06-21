import 'package:dio/dio.dart';
import 'package:flowerstore/scene/dashboard/data/model/add_customer.dart';
import 'package:flowerstore/scene/dashboard/data/model/customer.dart';
import 'package:flowerstore/scene/dashboard/data/model/patch_customer.dart';

abstract class DashboardRemoteDataSource {
  Future<List<Customer>> getCustomers();

  Future<List<Customer>> postCustomers(AddCustomer request);

  Future<List<Customer>> patchCustomers(int id, PatchCustomer request);

  Future<List<Customer>> deleteCustomers(int id);
}

class DashboardRemoteDataSourceImpl implements DashboardRemoteDataSource {
  final Dio dio;

  DashboardRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Customer>> getCustomers() async {
    try {
      final response = await dio.get('customers');

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final customersData = jsonResponse['Customers'] as List<dynamic>;

        return customersData
            .map<Customer>((json) => Customer.fromJson(json))
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
  Future<List<Customer>> deleteCustomers(int id) async {
    try {
      final response = await dio.delete(
        'customers/$id',
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

    return await getCustomers();
  }

  @override
  Future<List<Customer>> postCustomers(AddCustomer request) async {
    try {
      await dio.post(
        'customers',
        data: request.toJson(),
        options: Options(
          contentType: 'application/json',
        ),
      );
    } catch (error) {
      print('Error: $error');
    }

    return await getCustomers();
  }

  @override
  Future<List<Customer>> patchCustomers(int id, PatchCustomer request) async {
    try {
      final response = await dio.patch(
        'customer/$id',
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

    return await getCustomers();
  }
}
