part of 'customer_bloc.dart';

@immutable
abstract class CustomerState extends Equatable {
  const CustomerState();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class CustomerInitial extends CustomerState {}

class CustomerLoading extends CustomerState {}

class CustomerAdded extends CustomerState {}

class CustomerPatched extends CustomerState {}

class CustomerDeleted extends CustomerState {}

class CustomerLoaded extends CustomerState {
  final List<Customer> customers;

  const CustomerLoaded({required this.customers});

  @override
  List<Object?> get props => [customers];

  @override
  bool? get stringify => false;
}

class CustomerError extends CustomerState {
  final String message;

  CustomerError({required this.message});

  @override
  List<Object?> get props => [message];
}