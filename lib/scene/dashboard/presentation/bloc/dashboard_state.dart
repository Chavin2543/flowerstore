part of 'dashboard_bloc.dart';

@immutable
abstract class DashboardState extends Equatable {
  const DashboardState();
}

class DashboardInitial implements DashboardState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class DashboardLoaded implements DashboardState {
  List<Customer> customers;

  DashboardLoaded(this.customers);

  @override
  List<Object?> get props => [customers];

  @override
  bool? get stringify => false;
}
