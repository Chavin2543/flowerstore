part of 'invoice_bloc.dart';

@immutable
abstract class InvoiceState extends Equatable {
  const InvoiceState();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class InvoiceLoading extends InvoiceState { }

class InvoiceInitial extends InvoiceState { }

class InvoicePatched extends InvoiceState { }

class InvoiceDeleted extends InvoiceState { }

class InvoiceCreated extends InvoiceState {
  int invoiceId;

  InvoiceCreated({required this.invoiceId});

  @override
  List<Object?> get props => [invoiceId];
}

class InvoiceLoaded extends InvoiceState {
  List<Invoice> invoices;

  InvoiceLoaded(this.invoices);

  @override
  List<Object?> get props => [invoices];

  @override
  bool? get stringify => false;
}

class InvoiceError extends InvoiceState {
  final String message;

  InvoiceError({required this.message});

  @override
  List<Object?> get props => [message];
}