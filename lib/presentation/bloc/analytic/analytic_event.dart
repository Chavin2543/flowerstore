part of 'analytic_bloc.dart';

@immutable
abstract class AnalyticEvent extends Equatable {
  const AnalyticEvent();
}

class GetAnalyticsEvent implements AnalyticEvent {
  final GetInvoiceRequest request;

  GetAnalyticsEvent({required this.request});

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}
