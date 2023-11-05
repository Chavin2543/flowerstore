part of 'analytic_bloc.dart';

@immutable
abstract class AnalyticState extends Equatable {
  const AnalyticState();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class AnalyticLoading extends AnalyticState { }

class AnalyticInitial extends AnalyticState { }

class AnalyticLoaded extends AnalyticState {
  List<Invoice> invoices;

  AnalyticLoaded(this.invoices);

  @override
  List<Object?> get props => [invoices];

  @override
  bool? get stringify => false;
}

class AnalyticError extends AnalyticState {
  final String message;

  const AnalyticError({required this.message});

  @override
  List<Object?> get props => [message];
}