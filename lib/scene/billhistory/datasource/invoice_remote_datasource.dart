import 'package:dio/dio.dart';
import 'package:flowerstore/scene/billhistory/model/add_invoice.dart';
import 'package:flowerstore/scene/billhistory/model/invoice.dart';
import 'package:flowerstore/scene/createbill/data/model/patch_product.dart';

abstract class InvoiceRemoteDataSource {
  Future<List<Invoice>> getInvoice();

  Future<List<Invoice>> getInvoiceById(int customerId);

  Future<List<Invoice>> postInvoice(AddInvoice request);

  Future<List<Invoice>> patchInvoice(PatchProduct request);

  Future<List<Invoice>> deleteInvoice(int id);
}

class InvoiceRemoteDataSourceImpl implements InvoiceRemoteDataSource {
  final Dio dio;

  InvoiceRemoteDataSourceImpl(this.dio);

  @override
  Future<List<Invoice>> getInvoice() async {
    try {
      final response = await dio.get('invoices');

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final invoiceData = jsonResponse['Invoices'] as List<dynamic>;

        return invoiceData
            .map<Invoice>((json) => Invoice.fromJson(json))
            .toList();
      } else {
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Product Error: ${error.toString()}');
    }

    return [];
  }

  Future<List<Invoice>> getInvoiceById(int customerId) async {
    try {
      final response = await dio.get('invoices/?customer_id=$customerId');

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final invoiceData = jsonResponse['Invoices'] as List<dynamic>;

        return invoiceData
            .map<Invoice>((json) => Invoice.fromJson(json))
            .toList();
      } else {
        print('API request failed with status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Product Error: ${error.toString()}');
    }

    return [];
  }

  @override
  Future<List<Invoice>> deleteInvoice(int id) async {
    try {
      final response = await dio.delete(
        'invoices/$id',
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

    return await getInvoice();
  }

  @override
  Future<List<Invoice>> postInvoice(AddInvoice request) async {
    try {
      await dio.post(
        'invoices',
        data: request.toJson(),
        options: Options(
          contentType: 'application/json',
        ),
      );
    } catch (error) {
      print('Error: $error');
    }

    return await getInvoice();
  }

  @override
  Future<List<Invoice>> patchInvoice(PatchProduct request) async {
    try {
      final response = await dio.patch(
        'invoices/${request.id}',
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

    return await getInvoice();
  }
}
