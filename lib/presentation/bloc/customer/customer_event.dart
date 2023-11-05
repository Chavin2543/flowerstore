part of 'customer_bloc.dart';

@immutable
abstract class CustomerEvent extends Equatable {
  const CustomerEvent();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class GetCustomerEvent extends CustomerEvent {
  final GetCustomerRequest request;

  const GetCustomerEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class AddCustomerEvent extends CustomerEvent {
  final AddCustomerRequest request;

  const AddCustomerEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class PatchCustomerEvent extends CustomerEvent {
  final PatchCustomerRequest request;

  const PatchCustomerEvent({required this.request});

  @override
  List<Object?> get props => [request];
}

class DeleteCustomerEvent extends CustomerEvent {
  final DeleteCustomerRequest request;

  const DeleteCustomerEvent({required this.request});

  @override
  List<Object?> get props => [request];
}
