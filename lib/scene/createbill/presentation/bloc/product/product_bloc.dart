import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowerstore/scene/createbill/data/datasource/product_remote_datasource.dart';
import 'package:flowerstore/scene/createbill/data/model/add_product.dart';
import 'package:flowerstore/scene/createbill/data/model/patch_product.dart';
import 'package:flowerstore/scene/createbill/data/model/product.dart';
import 'package:meta/meta.dart';

part 'product_event.dart';

part 'product_state.dart';

class ProductBloc extends Bloc<ProductEvent, ProductState> {
  final ProductRemoteDataSource _dataSource;

  ProductBloc(this._dataSource) : super(ProductInitial()) {
    on<GetProductsEvent>(
        (event, emit) async => _onGetProductsEvent(event, emit));
    on<PostProductEvent>(
        (event, emit) async => _onPostProductsEvent(event, emit));
    on<PatchProductEvent>((event, emit) async => _onPatchProduct(event, emit));
    on<QueryProductByCategoryEvent>(
        (event, emit) async => _onQueryProductByCategoryEvent(event, emit));
    on<QueryProductByTextEvent>(
        (event, emit) async => _onQueryProductByTextEvent(event, emit));
  }

  _onGetProductsEvent(
      GetProductsEvent event, Emitter<ProductState> emit) async {
    emit(ProductsLoaded([]));
    final response = await _dataSource.getProducts();

    emit(
      ProductsLoaded(
        response
            .where((element) => element.customerId == event.customerId)
            .toList(),
      ),
    );
  }

  _onPostProductsEvent(
      PostProductEvent event, Emitter<ProductState> emit) async {
    final response = await _dataSource.postProducts(event.request);
    emit(ProductsLoaded(response));
  }

  _onQueryProductByCategoryEvent(
      QueryProductByCategoryEvent event, Emitter<ProductState> emit) async {
    final response = await _dataSource.getProducts();

    emit(
      ProductsLoaded(
        response
            .where((element) => element.categoryId == event.categoryId)
            .where((element) => element.customerId == event.customerId)
            .toList(),
      ),
    );
  }

  _onPatchProduct(PatchProductEvent event, Emitter<ProductState> emit) async {
    final response = await _dataSource.patchProducts(event.request);
  }

  _onQueryProductByTextEvent(
    QueryProductByTextEvent event,
    Emitter<ProductState> emit,
  ) async {
    final response = await _dataSource.getProducts();

    if (event.categoryId != null) {
      emit(ProductsLoaded(response
          .where((element) => element.name.contains(event.searchText))
          .where((element) => element.customerId == event.customerId)
          .where((element) => element.categoryId == event.categoryId)
          .toList()));
    } else {
      emit(ProductsLoaded(response
          .where((element) => element.name.toLowerCase().contains(event.searchText.toLowerCase()))
          .where((element) => element.customerId == event.customerId)
          .toList()));
    }
  }
}
