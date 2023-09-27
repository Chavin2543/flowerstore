part of 'category_bloc.dart';

@immutable
abstract class CategoryEvent extends Equatable {
  const CategoryEvent();
}

class GetCategoriesEvent implements CategoryEvent {
  DateTime timeStamp;
  int customerId;

  GetCategoriesEvent(this.timeStamp, this.customerId);

  @override
  List<Object?> get props => [timeStamp, customerId];

  @override
  bool? get stringify => false;
}

class PostCategoryEvent implements CategoryEvent {
  final AddCategory request;

  PostCategoryEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class PatchCategoryEvent implements CategoryEvent {
  final PatchCategory request;

  PatchCategoryEvent(this.request);

  @override
  List<Object?> get props => [request];

  @override
  bool? get stringify => false;
}

class QueryCategoryEvent implements CategoryEvent {
  final String searchText;
  final int customerId;

  QueryCategoryEvent(this.searchText, this.customerId);

  @override
  List<Object?> get props => [searchText, customerId];

  @override
  bool? get stringify => false;
}



