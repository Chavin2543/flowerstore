import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowerstore/scene/createbill/data/datasource/category_remote_datasource.dart';
import 'package:flowerstore/scene/createbill/data/model/add_category.dart';
import 'package:flowerstore/scene/createbill/data/model/category.dart';
import 'package:flowerstore/scene/createbill/data/model/patch_category.dart';
import 'package:meta/meta.dart';

part 'category_event.dart';

part 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryRemoteDataSource _dataSource;

  CategoryBloc(this._dataSource) : super(CategoryInitial()) {
    on<GetCategoriesEvent>(
        (event, emit) async => _onGetCategoriesEvent(event, emit));
    on<PostCategoryEvent>(
        (event, emit) async => _onPostCategoryEvent(event, emit));
    on<QueryCategoryEvent>(
        (event, emit) async => _onQueryCategoryEvent(event, emit));
  }

  _onGetCategoriesEvent(
      GetCategoriesEvent event, Emitter<CategoryState> emit) async {
    emit(CategoriesLoaded([]));
    final response = await _dataSource.getCategories();
    emit(
      CategoriesLoaded(
        response.where((element) => element.customerId == event.customerId).toList(),
      ),
    );
  }

  _onPostCategoryEvent(
      PostCategoryEvent event, Emitter<CategoryState> emit) async {
    final response = await _dataSource.postCategories(event.request);
    emit(CategoriesLoaded(response));
  }

  _onQueryCategoryEvent(
      QueryCategoryEvent event, Emitter<CategoryState> emit) async {
    final response = await _dataSource.getCategories();
    emit(
      CategoriesLoaded(
        response
            .where((element) => element.name.contains(event.searchText))
            .where((element) => element.customerId == event.customerId)
            .toList(),
      ),
    );
  }
}
