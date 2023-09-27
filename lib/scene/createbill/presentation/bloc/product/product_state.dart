part of 'product_bloc.dart';

@immutable
abstract class ProductState extends Equatable {
  const ProductState();
}

class ProductInitial implements ProductState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class ProductsLoaded implements ProductState {
  List<Product> products;

  ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];

  @override
  bool? get stringify => false;
}
