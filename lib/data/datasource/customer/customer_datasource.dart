import 'package:dio/dio.dart';
import 'package:flowerstore/domain/entity/customer.dart';

import '../../../helper/error_manager.dart';
import '../../api_error.dart';
import 'model/add_customer_request.dart';
import 'model/delete_customer_request.dart';
import 'model/get_customer_request.dart';
import 'model/patch_customer_request.dart';

abstract class CustomerDataSource {
  Future<List<Customer>> getCustomer(GetCustomerRequest request);

  Future<List<Customer>> addCustomer(AddCustomerRequest request);

  Future<List<Customer>> patchCustomer(PatchCustomerRequest request);

  Future<List<Customer>> deleteCustomer(DeleteCustomerRequest request);
}

class CustomerDataSourceImpl implements CustomerDataSource {
  final Dio dio;

  CustomerDataSourceImpl(this.dio);

  @override
  Future<List<Customer>> getCustomer(GetCustomerRequest request) async {
    try {
      final response = await dio.get('customers');

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final customersData = jsonResponse['customers'] as List<dynamic>;
        return customersData
            .map<Customer>((json) => Customer.fromJson(json))
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
  Future<List<Customer>> deleteCustomer(DeleteCustomerRequest request) async {
    try {
      final response = await dio.delete(
        'customers/${request.customerId}',
      );
      if (response.statusCode != 200) {
        throw APIError(
            'DELETE request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await getCustomer(GetCustomerRequest());
  }

  @override
  Future<List<Customer>> addCustomer(AddCustomerRequest request) async {
    try {
      await dio.post('customers',
          data: request.toJson(),
          options: Options(
            contentType: 'application/json',
          ));
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }
    return await getCustomer(GetCustomerRequest());
  }

  @override
  Future<List<Customer>> patchCustomer(PatchCustomerRequest request) async {
    try {
      final response = await dio.patch(
        'customers/${request.customerId}',
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

    return await getCustomer(GetCustomerRequest());
  }
}
