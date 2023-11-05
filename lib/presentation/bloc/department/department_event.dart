part of 'department_bloc.dart';

@immutable
abstract class DepartmentEvent extends Equatable {
  const DepartmentEvent();
}

class GetDepartmentEvent implements DepartmentEvent {
  final GetDepartmentRequest request;
  GetDepartmentEvent({required this.request});

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class AddDepartmentEvent implements DepartmentEvent {
  final AddDepartmentRequest request;

  AddDepartmentEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class PatchDepartmentEvent implements DepartmentEvent {
  final PatchDepartmentRequest request;

  PatchDepartmentEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class DeleteDepartmentEvent implements DepartmentEvent {
  final DeleteDepartmentRequest request;

  DeleteDepartmentEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class QueryDepartmentEvent implements DepartmentEvent {
  final String searchText;

  QueryDepartmentEvent(this.searchText);

  @override
  List<Object?> get props => [searchText];

  @override
  bool? get stringify => false;
}



