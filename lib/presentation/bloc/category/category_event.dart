part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class GetCategoriesEvent implements CategoryEvent {
  final GetCategoryRequest request;
  GetCategoriesEvent({required this.request});

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class AddCategoryEvent implements CategoryEvent {
  final AddCategoryRequest request;

  AddCategoryEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class PatchCategoryEvent implements CategoryEvent {
  final PatchCategoryRequest request;

  PatchCategoryEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class DeleteCategoryEvent implements CategoryEvent {
  final DeleteCategoryRequest request;

  DeleteCategoryEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class QueryCategoryEvent implements CategoryEvent {
  final String searchText;

  QueryCategoryEvent(this.searchText);

  @override
  List<Object?> get props => [searchText];

  @override
  bool? get stringify => false;
}



