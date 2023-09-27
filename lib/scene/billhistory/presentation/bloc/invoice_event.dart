part of 'invoice_bloc.dart';

@immutable
abstract class InvoiceEvent extends Equatable {
  const InvoiceEvent();
}

class GetInvoicesEvent implements InvoiceEvent {
  DateTime timeStamp;
  int customerId;

  GetInvoicesEvent(this.timeStamp, this.customerId);

  @override
  List<Object?> get props => [timeStamp, customerId];

  @override
  bool? get stringify => false;
}

class PostInvoicesEvent implements InvoiceEvent {
  final AddInvoice request;

  PostInvoicesEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class PatchInvoiceEvent implements InvoiceEvent {
  final PatchInvoice request;

  PatchInvoiceEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class QueryInvoiceEvent implements InvoiceEvent {
  final int customerId;

  QueryInvoiceEvent(this.customerId);

  @override
  List<Object?> get props => [customerId];

  @override
  bool? get stringify => false;
}



