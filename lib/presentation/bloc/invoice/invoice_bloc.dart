// Dart imports:
import 'dart:async';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowerstore/data/api_error.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/delete_invoice_request.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:flowerstore/data/datasource/invoice/invoice_datasource.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/get_invoice_item_by_invoice_id_request.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/patch_invoice_request.dart';
import 'package:flowerstore/data/datasource/product/model/get_product_by_id_request.dart';
import 'package:flowerstore/data/datasource/product/product_datasource.dart';
import 'package:flowerstore/domain/entity/bill_item.dart';
import 'package:flowerstore/domain/entity/invoice.dart';
import 'package:flowerstore/domain/entity/invoice_item.dart';
import 'package:flowerstore/domain/entity/product.dart';
import 'package:flowerstore/helper/customer_store.dart';
import '../../../data/datasource/invoice/model/request/add_invoice_request.dart';
import '../../../data/datasource/invoice/model/request/get_invoice_request.dart';

// Part files:
part 'invoice_event.dart';

part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceDataSource _dataSource;
  final ProductDatasource _productRemoteDataSource;

  InvoiceBloc(this._dataSource, this._productRemoteDataSource)
      : super(InvoiceInitial()) {
    on<GetInvoicesEvent>(
        (event, emit) async => _onGetInvoicesEvent(event, emit));
    on<AddInvoicesEvent>(
        (event, emit) async => _onAddInvoiceEvent(event, emit));
    on<PatchInvoiceEvent>(
        (event, emit) async => _onPatchInvoiceEvent(event, emit));
    on<DeleteInvoiceEvent>(
            (event, emit) async => _onDeleteInvoiceEvent(event, emit));
  }

  _onGetInvoicesEvent(
      GetInvoicesEvent event, Emitter<InvoiceState> emit) async {
    final cacheState = state;

    emit(InvoiceLoading());

    try {
      final response = await _dataSource.getInvoice(event.request);

      emit(
        InvoiceLoaded(response
            .where(
              (element) =>
                  element.customerId == CustomerStore.getCustomerId() ||
                  !event.shouldFilter,
            )
            .toList()),
      );
    } on APIError catch (error) {
      emit(InvoiceError(message: error.message));

      if (cacheState is InvoiceLoaded) {
        emit(cacheState);
      } else {
        emit(InvoiceLoaded(const []));
      }
    }
  }

  _onAddInvoiceEvent(AddInvoicesEvent event, Emitter<InvoiceState> emit) async {
    final cacheState = state;

    emit(InvoiceLoading());

    try {
      final response = await _dataSource.addInvoice(event.request);
      emit(InvoiceCreated(invoiceId: response));
    } on APIError catch (error) {
      emit(InvoiceError(message: error.message));
      if (cacheState is InvoiceLoaded) {
        emit(cacheState);
      } else {
        emit(InvoiceLoaded(const []));
      }
    }
  }

  _onPatchInvoiceEvent(
      PatchInvoiceEvent event, Emitter<InvoiceState> emit) async {
    final cacheState = state;

    emit(InvoiceLoading());

    try {
      final response = await _dataSource.patchInvoice(event.request);

      emit(
        InvoiceLoaded(
            response
                .where((element) =>
            element.customerId == CustomerStore.getCustomerId())
                .toList()
        ),
      );
    } on APIError catch (error) {
      emit(InvoiceError(message: error.message));

      if (cacheState is InvoiceLoaded) {
        emit(cacheState);
      } else {
        emit(InvoiceLoaded(const []));
      }
    }
  }

  _onDeleteInvoiceEvent(
      DeleteInvoiceEvent event, Emitter<InvoiceState> emit) async {
    final cacheState = state;

    emit(InvoiceLoading());

    try {
      final response = await _dataSource.deleteInvoice(event.request);

      emit(
        InvoiceLoaded(
            response
                .where((element) =>
            element.customerId == CustomerStore.getCustomerId())
                .toList()
        ),
      );
    } on APIError catch (error) {
      emit(InvoiceError(message: error.message));

      if (cacheState is InvoiceLoaded) {
        emit(cacheState);
      } else {
        emit(InvoiceLoaded(const []));
      }
    }
  }

  Future<List<BillItem>> getInitialInvoiceItem(int invoiceId) async {
    List<InvoiceItem> response = await _dataSource.getInvoiceItemByInvoiceId(GetInvoiceItemByInvoiceId(invoiceId: invoiceId));
    List<BillItem> items = await Future.wait(response.map((InvoiceItem invoiceItem) async {
      Product product = await _productRemoteDataSource.getProductById(GetProductByIdRequest(id: invoiceItem.product_id)) ??
          Product(
            id: 0,
            name: "Unknown",
            categoryId: 0,
            customerId: 0,
            price: 0,
            unit: "Unknown",
          );

      BillItem billItem = BillItem(quantity: invoiceItem.quantity, product: product);

      return billItem;
    }).toList());

    return items;
  }

  Future<int> generateInvoiceId() async {
    try {
      final response = await _dataSource.getInvoice(GetInvoiceRequest());
      return response.where((element) => element.customerId == CustomerStore.getCustomerId()).toList().length + 1;
    } on APIError catch (error) {
      return 0;
    }
  }
}
