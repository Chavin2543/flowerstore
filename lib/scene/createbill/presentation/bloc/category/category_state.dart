part of 'category_bloc.dart';

@immutable
abstract class CategoryState extends Equatable {
  const CategoryState();
}

class CategoryInitial implements CategoryState {
  @override
  List<Object?> get props => [];

  @override
  bool? get stringify => false;
}

class CategoriesLoaded implements CategoryState {
  List<Category> categories;

  CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];

  @override
  bool? get stringify => false;
}
