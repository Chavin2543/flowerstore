part of '../../../../../presentation/bloc/category/category_bloc.dart';

@immutable
abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class CategoryLoading extends CategoryState {}

class CategoryInitial extends CategoryState {}

class CategoryAdded extends CategoryState {}

class CategoryPatched extends CategoryState {}

class CategoryDeleted extends CategoryState {}

class CategoriesLoaded extends CategoryState {
  List<Category> categories;

  CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];

  @override
  bool? get stringify => false;
}

class CategoryError extends CategoryState {
  final String message;

  CategoryError({required this.message});

  @override
  List<Object?> get props => [message];
}