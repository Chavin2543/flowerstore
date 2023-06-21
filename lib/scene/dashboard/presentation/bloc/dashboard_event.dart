part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
}

class GetCustomersEvent implements DashboardEvent {
  DateTime timeStamp;

  GetCustomersEvent(this.timeStamp);

  @override
  List<Object?> get props => [timeStamp];

  @override
  bool? get stringify => false;
}

class PostCustomersEvent implements DashboardEvent {
  final AddCustomer request;

  PostCustomersEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}