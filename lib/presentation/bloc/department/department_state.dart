part of 'department_bloc.dart';

@immutable
abstract class DepartmentState extends Equatable {
  const DepartmentState();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class DepartmentLoading extends DepartmentState {}

class DepartmentInitial extends DepartmentState {}

class DepartmentAdded extends DepartmentState {}

class DepartmentPatched extends DepartmentState {}

class DepartmentDeleted extends DepartmentState {}

class DepartmentLoaded extends DepartmentState {
  List<String> departments;

  DepartmentLoaded(this.departments);

  @override
  List<Object?> get props => [departments];

  @override
  bool? get stringify => false;
}

class DepartmentError extends DepartmentState {
  final String message;

  DepartmentError({required this.message});

  @override
  List<Object?> get props => [message];
}