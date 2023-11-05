part of 'invoice_bloc.dart';

@immutable
abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();
}

class GetInvoicesEvent implements InvoiceEvent {
  final GetInvoiceRequest request;
  final bool shouldFilter;

  GetInvoicesEvent({required this.request, required this.shouldFilter});

  @override
  List<Object?> get props => [request, shouldFilter];

  @override
  bool? get stringify => false;
}

class AddInvoicesEvent implements InvoiceEvent {
  final AddInvoiceRequest request;

  AddInvoicesEvent({required this.request});

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class PatchInvoiceEvent implements InvoiceEvent {
  final PatchInvoiceRequest request;

  PatchInvoiceEvent({required this.request});

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}