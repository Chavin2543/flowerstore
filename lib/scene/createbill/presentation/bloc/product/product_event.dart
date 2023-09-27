part of 'product_bloc.dart';

@immutable
abstract class ProductEvent extends Equatable {
  const ProductEvent();
}

class GetProductsEvent implements ProductEvent {
  DateTime timeStamp;
  int customerId;

  GetProductsEvent(this.timeStamp, this.customerId);

  @override
  List<Object?> get props => [timeStamp, customerId];

  @override
  bool? get stringify => false;
}

class PostProductEvent implements ProductEvent {
  final AddProduct request;

  PostProductEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class PatchProductEvent implements ProductEvent {
  final PatchProduct request;

  PatchProductEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class QueryProductByCategoryEvent implements ProductEvent {
  final int categoryId;
  final int customerId;

  QueryProductByCategoryEvent(this.categoryId, this.customerId);

  @override
  List<Object?> get props => [categoryId, customerId];

  @override
  bool? get stringify => false;
}

class QueryProductByTextEvent implements ProductEvent {
  final String searchText;
  final int customerId;
  final int? categoryId;

  QueryProductByTextEvent(
    this.searchText,
    this.customerId, {
    this.categoryId,
  });

  @override
  List<Object?> get props => [searchText, customerId, categoryId];

  @override
  bool? get stringify => false;
}
