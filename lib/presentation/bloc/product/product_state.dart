part of 'product_bloc.dart';

@immutable
abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class ProductLoading extends ProductState { }

class ProductInitial extends ProductState { }

class ProductAdded extends ProductState { }

class ProductDeleted extends ProductState { }

class ProductPatched extends ProductState { }

class ProductsLoaded extends ProductState {
  List<Product> products;

  ProductsLoaded(this.products);

  @override
  List<Object?> get props => [products];

  @override
  bool? get stringify => false;
}

class ProductError extends ProductState {
  final String message;

  ProductError({required this.message});

  @override
  List<Object?> get props => [message];
}