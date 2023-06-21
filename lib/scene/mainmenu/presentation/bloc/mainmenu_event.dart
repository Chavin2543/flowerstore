part of 'mainmenu_bloc.dart';

@immutable
abstract class MainmenuEvent extends Equatable {
  const MainmenuEvent();
}

class PutCustomersEvent implements MainmenuEvent {
  final AddCustomer request;

  PutCustomersEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class DeleteCustomersEvent implements MainmenuEvent {
  final int id;

  DeleteCustomersEvent(this.id);

  @override
  List<Object?> get props => [id];

  @override
  bool? get stringify => false;
}

class PatchCustomersEvent implements MainmenuEvent {
  final int id;
  final PatchCustomer request;

  PatchCustomersEvent(this.id, this.request);

  @override
  List<Object?> get props => [id, request];

  @override
  bool? get stringify => false;
}
