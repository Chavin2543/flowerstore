part of 'product_bloc.dart';

@immutable
abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class GetProductEvent implements ProductEvent {
  final GetProductRequest request;

  GetProductEvent({required this.request});

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class AddProductEvent implements ProductEvent {
  final AddProductRequest request;

  AddProductEvent({required this.request});

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class DeleteProductEvent implements ProductEvent {
  final DeleteProductRequest request;

  DeleteProductEvent({required this.request});

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class PatchProductEvent implements ProductEvent {
  final PatchProductRequest request;

  PatchProductEvent({required this.request});

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class QueryProductByCategoryEvent implements ProductEvent {
  final int categoryId;

  QueryProductByCategoryEvent(this.categoryId);

  @override
  List<Object?> get props => [categoryId];

  @override
  bool? get stringify => false;
}

class QueryProductByTextEvent implements ProductEvent {
  final String searchText;
  final int? categoryId;

  QueryProductByTextEvent(
    this.searchText, {
    this.categoryId,
  });

  @override
  List<Object?> get props => [searchText, categoryId];

  @override
  bool? get stringify => false;
}
