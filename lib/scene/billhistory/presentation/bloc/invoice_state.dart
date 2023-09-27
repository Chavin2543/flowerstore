part of 'invoice_bloc.dart';

@immutable
abstract class InvoiceState extends Equatable {
  const InvoiceState();
}

class InvoiceInitial implements InvoiceState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class InvoiceLoaded implements InvoiceState {
  List<Invoice> invoices;

  InvoiceLoaded(this.invoices);

  @override
  List<Object?> get props => [invoices];

  @override
  bool? get stringify => false;
}
