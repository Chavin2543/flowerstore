// Dart imports:
import 'package:flowerstore/data/api_error.dart';
import 'package:meta/meta.dart';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:flowerstore/data/datasource/category/category_datasource.dart';
import 'package:flowerstore/data/datasource/category/model/request/add_category_request.dart';
import 'package:flowerstore/data/datasource/category/model/request/get_category_request.dart';
import 'package:flowerstore/data/datasource/category/model/request/patch_category_request.dart';
import 'package:flowerstore/domain/entity/category.dart';
import 'package:flowerstore/helper/customer_store.dart';

import '../../../data/datasource/category/model/request/delete_category_request.dart';

// Part files:
part 'category_event.dart';

part 'category_state.dart';


class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final CategoryDataSource _dataSource;

  CategoryBloc(this._dataSource) : super(CategoryInitial()) {
    on<GetCategoriesEvent>((event, emit) async =>
        _onGetCategoriesEvent(event, emit));
    on<AddCategoryEvent>((event, emit) async =>
        _onPostCategoryEvent(event, emit));
    on<PatchCategoryEvent>((event, emit) async =>
        _onPatchCategoryEvent(event, emit));
    on<DeleteCategoryEvent>((event, emit) async =>
        _onDeleteCategoryEvent(event, emit));
    on<QueryCategoryEvent>((event, emit) async =>
        _onQueryCategoryEvent(event, emit));
  }

  _onGetCategoriesEvent(GetCategoriesEvent event,
      Emitter<CategoryState> emit) async {
    final cacheState = state;

    emit(CategoryLoading());

    try {
      final response = await _dataSource.getCategory(event.request);

      emit(
        CategoriesLoaded(
          response
              .where((element) =>
          element.customerId == CustomerStore.getCustomerId())
              .toList(),
        ),
      );
    } on APIError catch (error) {
      emit(CategoryError(message: error.message));

      if (cacheState is CategoriesLoaded) {
        emit(cacheState);
      } else {
        emit(CategoriesLoaded(const []));
      }
    }
  }

  _onPostCategoryEvent(AddCategoryEvent event,
      Emitter<CategoryState> emit) async {
    final cacheState = state;

    emit(CategoryLoading());

    try {
      final response = await _dataSource.addCategory(event.request);
      emit(
        CategoriesLoaded(
          response
              .where((element) =>
          element.customerId == CustomerStore.getCustomerId())
              .toList(),
        ),
      );
    } on APIError catch (error) {
      emit(CategoryError(message: error.message));

      if (cacheState is CategoriesLoaded) {
        emit(cacheState);
      } else {
        emit(CategoriesLoaded(const []));
      }
    }
  }

  _onPatchCategoryEvent(PatchCategoryEvent event,
      Emitter<CategoryState> emit) async {
    final cacheState = state;

    emit(CategoryLoading());

    try {
      final response = await _dataSource.patchCategory(event.request);
      emit(
        CategoriesLoaded(
          response
              .where((element) =>
          element.customerId == CustomerStore.getCustomerId())
              .toList(),
        ),
      );
    } on APIError catch (error) {
      emit(CategoryError(message: error.message));

      if (cacheState is CategoriesLoaded) {
        emit(cacheState);
      } else {
        emit(CategoriesLoaded(const []));
      }
    }
  }

  _onDeleteCategoryEvent(DeleteCategoryEvent event,
      Emitter<CategoryState> emit) async {
    final cacheState = state;

    emit(CategoryLoading());

    try {
      final response = await _dataSource.deleteCategory(event.request);
      emit(
        CategoriesLoaded(
          response
              .where((element) =>
          element.customerId == CustomerStore.getCustomerId())
              .toList(),
        ),
      );
    } on APIError catch (error) {
      emit(CategoryError(message: error.message));

      if (cacheState is CategoriesLoaded) {
        emit(cacheState);
      } else {
        emit(CategoriesLoaded(const []));
      }
    }
  }

  _onQueryCategoryEvent(QueryCategoryEvent event,
      Emitter<CategoryState> emit) async {
    final cacheState = state;

    try {
      final response = await _dataSource.getCategory(
          const GetCategoryRequest());
      emit(
        CategoriesLoaded(
          response
              .where((element) => element.name.contains(event.searchText))
              .where((element) =>
          element.customerId == CustomerStore.getCustomerId())
              .toList(),
        ),
      );
    } on APIError catch (error) {
      emit(CategoryError(message: error.message));

      if (cacheState is CategoriesLoaded) {
        emit(cacheState);
      } else {
        emit(CategoriesLoaded(const []));
      }
    }
  }
}
