// Package imports:
import 'package:equatable/equatable.dart';
import 'package:flowerstore/data/api_error.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:flowerstore/data/datasource/product/model/add_product_request.dart';
import 'package:flowerstore/data/datasource/product/model/get_product_request.dart';
import 'package:flowerstore/data/datasource/product/model/patch_product_request.dart';
import 'package:flowerstore/data/datasource/product/product_datasource.dart';
import 'package:flowerstore/domain/entity/product.dart';
import 'package:flowerstore/helper/customer_store.dart';

// Part files:
part 'product_event.dart';
part 'product_state.dart';


class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductDatasource _dataSource;

  ProductBloc(this._dataSource) : super(ProductInitial()) {
    on<GetProductEvent>((event, emit) async => _onGetProductsEvent(event, emit));
    on<AddProductEvent>((event, emit) async => _onPostProductsEvent(event, emit));
    on<PatchProductEvent>((event, emit) async => _onPatchProduct(event, emit));
    on<QueryProductByCategoryEvent>((event, emit) async => _onQueryProductByCategoryEvent(event, emit));
    on<QueryProductByTextEvent>((event, emit) async => _onQueryProductByTextEvent(event, emit));
  }

  _onGetProductsEvent(GetProductEvent event, Emitter<ProductState> emit) async {
    final cacheState = state;

    emit(ProductLoading());

    try {
      final response = await _dataSource.getProduct(GetProductRequest());

      emit(
        ProductsLoaded(
          response
              .where((element) => element.customerId == CustomerStore.getCustomerId())
              .toList(),
        ),
      );
    } on APIError catch (error) {
      emit(ProductError(message: error.message));

      if (cacheState is ProductsLoaded) {
        emit(cacheState);
      } else {
        emit(ProductsLoaded(const []));
      }
    }
  }

  _onPostProductsEvent(AddProductEvent event, Emitter<ProductState> emit) async {
    final cacheState = state;

    emit(ProductLoading());

    try {
      final response = await _dataSource.addProduct(event.request);

      emit(
        ProductsLoaded(
          response
              .where((element) => element.customerId == CustomerStore.getCustomerId())
              .toList(),
        ),
      );
    } on APIError catch (error) {
      emit(ProductError(message: error.message));

      if (cacheState is ProductsLoaded) {
        emit(cacheState);
      } else {
        emit(ProductsLoaded(const []));
      }
    }
  }

  _onQueryProductByCategoryEvent(
      QueryProductByCategoryEvent event, Emitter<ProductState> emit) async {
    final cacheState = state;

    emit(ProductLoading());

    try {
      final response = await _dataSource.getProduct(GetProductRequest());

      emit(
        ProductsLoaded(
          response
              .where((element) => element.categoryId == event.categoryId)
              .where((element) => element.customerId == CustomerStore.getCustomerId())
              .toList(),
        ),
      );
    } on APIError catch (error) {
      emit(ProductError(message: error.message));

      if (cacheState is ProductsLoaded) {
        emit(cacheState);
      } else {
        emit(ProductsLoaded(const []));
      }
    }
  }

  _onPatchProduct(PatchProductEvent event, Emitter<ProductState> emit) async {
    final cacheState = state;

    emit(ProductLoading());

    try {
      final response = await _dataSource.patchProduct(event.request);

      emit(
        ProductsLoaded(
          response
              .where((element) => element.customerId == CustomerStore.getCustomerId())
              .toList(),
        ),
      );
    } on APIError catch (error) {
      emit(ProductError(message: error.message));

      if (cacheState is ProductsLoaded) {
        emit(cacheState);
      } else {
        emit(ProductsLoaded(const []));
      }
    }
  }

  _onQueryProductByTextEvent(
    QueryProductByTextEvent event,
    Emitter<ProductState> emit,
  ) async {
    final cacheState = state;

    try {
      final response = await _dataSource.getProduct(GetProductRequest());

      if (event.categoryId != null) {
        emit(ProductsLoaded(response
            .where((element) => element.name.contains(event.searchText))
            .where((element) => element.categoryId == event.categoryId)
            .where((element) => element.customerId == CustomerStore.getCustomerId())
            .toList()));
      } else {
        emit(ProductsLoaded(response
            .where((element) => element.name.toLowerCase().contains(event.searchText.toLowerCase()))
            .where((element) => element.customerId == CustomerStore.getCustomerId())
            .toList()));
      }
    } on APIError catch (error) {
      emit(ProductError(message: error.message));

      if (cacheState is ProductsLoaded) {
        emit(cacheState);
      } else {
        emit(ProductsLoaded(const []));
      }
    }
  }
}
