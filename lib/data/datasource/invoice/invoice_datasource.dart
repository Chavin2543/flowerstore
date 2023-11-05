import 'package:dio/dio.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/add_invoice_item_request.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/add_invoice_items_request.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/add_invoice_request.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/delete_invoice_item_by_invoice_id.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/delete_invoice_request.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/get_invoice_by_id_request.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/get_invoice_item_by_invoice_id_request.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/get_invoice_request.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/patch_invoice_request.dart';
import 'package:flowerstore/domain/entity/invoice.dart';
import 'package:flowerstore/domain/entity/invoice_item.dart';

import '../../../helper/error_manager.dart';
import '../../api_error.dart';

abstract class InvoiceDataSource {
  Future<List<Invoice>> getInvoice(GetInvoiceRequest request);
  Future<int> addInvoice(AddInvoiceRequest request);
  Future<List<Invoice>> patchInvoice(PatchInvoiceRequest request);
  Future<List<Invoice>> deleteInvoice(DeleteInvoiceRequest request);
  Future<List<Invoice>> deleteInvoiceItemByInvoiceId(DeleteInvoiceItemByInvoiceId request);
  Future<List<Invoice>> getInvoiceById(GetInvoiceByIdRequest request);
  Future<List<Invoice>> addInvoiceItem(AddInvoiceItemRequest request);
  Future<List<InvoiceItem>> getInvoiceItemByInvoiceId(GetInvoiceItemByInvoiceId request);
}

class InvoiceDataSourceImpl implements InvoiceDataSource {
  final Dio dio;

  InvoiceDataSourceImpl(this.dio);

  @override
  Future<List<Invoice>> getInvoice(GetInvoiceRequest request) async {
    try {
      final response = await dio.get('invoices');
      if (response.statusCode! >= 200 && response.statusCode! <= 204) {
        final List<dynamic> invoiceData = response.data['Invoices'];
        return invoiceData
            .map<Invoice>((json) => Invoice.fromJson(json))
            .toList();
      }

      throw APIError(
          'Failed to fetch invoices. Status code: ${response.statusCode}');
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }
  }

  @override
  Future<List<Invoice>> getInvoiceById(GetInvoiceByIdRequest request) async {
    try {
      final response =
          await dio.get('invoices/?customer_id=${request.customerId}');
      if (response.statusCode! >= 200 && response.statusCode! <= 204) {
        final List<dynamic> invoiceData = response.data['Invoices'];
        return invoiceData
            .map<Invoice>((json) => Invoice.fromJson(json))
            .toList();
      }

      throw APIError(
          'Failed to fetch invoices by ID. Status code: ${response.statusCode}');
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }
  }

  @override
  Future<List<InvoiceItem>> getInvoiceItemByInvoiceId(
      GetInvoiceItemByInvoiceId request) async {
    try {
      final response =
          await dio.get('invoice-items?invoice_id=${request.invoiceId}');
      if (response.statusCode! >= 200 && response.statusCode! <= 204) {
        final List<dynamic> invoiceItemData = response.data['InvoiceItems'];
        return invoiceItemData
            .map<InvoiceItem>((json) => InvoiceItem.fromJson(json))
            .toList();
      }

      throw APIError(
          'Failed to fetch invoice items by ID. Status code: ${response.statusCode}');
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }
  }

  @override
  Future<List<Invoice>> deleteInvoice(DeleteInvoiceRequest request) async {
    try {
      final response = await dio.delete(
        'invoices/${request.invoiceId}',
        options: Options(contentType: 'application/json'),
      );

      if (response.statusCode! <= 200 && response.statusCode! >= 204) {
        throw APIError(
            'DELETE request failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await refreshInvoice();
  }

  @override
  Future<List<Invoice>> deleteInvoiceItemByInvoiceId(DeleteInvoiceItemByInvoiceId request) async {
    try {
      final response = await dio.delete(
        'invoice-items?invoice_id=${request.invoiceId}',
        options: Options(contentType: 'application/json'),
      );

      if (response.statusCode! <= 200 && response.statusCode! >= 204) {
        throw APIError(
            'DELETE request failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await refreshInvoice();
  }

  @override
  Future<int> addInvoice(AddInvoiceRequest request) async {
    try {
      final int invoiceId = await createInvoice(request);
      if (request.billItems.isEmpty) { return invoiceId; }
      addInvoiceItems(AddInvoiceItemsRequest(invoiceId: invoiceId, billItem: request.billItems));
      return invoiceId;
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }
  }

  Future<void> addInvoiceItems(AddInvoiceItemsRequest request) async {
    for (var element in request.billItem) {
      addInvoiceItem(AddInvoiceItemRequest(
          quantity: element.quantity,
          totalPrice: element.quantity * element.product.price,
          invoiceId: request.invoiceId,
          productId: element.product.id,
          categoryId: element.product.categoryId));
    }
  }

  @override
  Future<List<Invoice>> addInvoiceItem(AddInvoiceItemRequest request) async {
    try {
      final response = await dio.post(
        'invoice-items',
        data: request.toJson(),
        options: Options(contentType: 'application/json'),
      );

      if (response.statusCode! <= 200 && response.statusCode! >= 204) {
        throw APIError(
            'POST request failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await refreshInvoice();
  }

  Future<int> createInvoice(AddInvoiceRequest request) async {
    final response = await dio.post(
      'invoices',
      data: request.toJson(),
      options: Options(contentType: 'application/json'),
    );

    if (response.statusCode! <= 200 && response.statusCode! >= 204) {
      throw APIError(
          'POST request failed. Status code: ${response.statusCode}');
    }

    return Invoice.fromJson(response.data['invoice']).id;
  }

  @override
  Future<List<Invoice>> patchInvoice(PatchInvoiceRequest request) async {
    try {
      final response = await dio.patch(
        'invoices/${request.invoiceId}',
        data: request.toJson(),
        options: Options(contentType: 'application/json'),
      );

      await deleteInvoiceItemByInvoiceId(DeleteInvoiceItemByInvoiceId(invoiceId: request.invoiceId));
      await addInvoiceItems(AddInvoiceItemsRequest(invoiceId: request.invoiceId, billItem: request.currentBillItem ?? []));

      if (response.statusCode! <= 200 && response.statusCode! >= 204) {
        throw APIError(
            'PATCH request failed. Status code: ${response.statusCode}');
      }
    } catch (error) {
      throw ErrorManager.handleAPIError(error);
    }

    return await refreshInvoice();
  }

  Future<List<Invoice>> refreshInvoice() async {
    return await getInvoice(GetInvoiceRequest());
  }
}
