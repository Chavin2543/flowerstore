import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowerstore/data/datasource/department/department_datasource.dart';
import 'package:flowerstore/domain/entity/department.dart';
import '../../../data/api_error.dart';
import '../../../data/datasource/department/model/delete_department_request.dart';

import '../../../data/datasource/department/model/get_department_request.dart';
import '../../../data/datasource/department/model/patch_department_request.dart';

import '../../../data/datasource/department/model/add_department_request.dart';
import 'package:meta/meta.dart';

part 'department_event.dart';
part 'department_state.dart';

class DepartmentBloc extends Bloc<DepartmentEvent, DepartmentState> {
  final DepartmentDataSource _dataSource;

  DepartmentBloc(this._dataSource) : super(DepartmentInitial()) {
    on<GetDepartmentEvent>((event, emit) async => _onGetDepartmentEvent(event, emit));
    on<AddDepartmentEvent>((event, emit) async => _onPostDepartmentEvent(event, emit));
    on<PatchDepartmentEvent>((event, emit) async => _onPatchDepartmentEvent(event, emit));
    on<DeleteDepartmentEvent>((event, emit) async => _onDeleteDepartmentEvent(event, emit));
    on<QueryDepartmentEvent>((event, emit) async => _onQueryDepartmentEvent(event, emit));
  }
  
  _onGetDepartmentEvent(GetDepartmentEvent event, Emitter<DepartmentState> emit) async {
    final cacheState = state;

    emit(DepartmentLoading());

    try {
      final response = await _dataSource.getDepartment(event.request);

      emit(
        DepartmentLoaded(response),
      );
    } on APIError catch (error) {
      emit(DepartmentError(message: error.message));

      if (cacheState is DepartmentLoaded) {
        emit(cacheState);
      } else {
        emit(DepartmentLoaded(const []));
      }
    }
  }

  _onPostDepartmentEvent(AddDepartmentEvent event, Emitter<DepartmentState> emit) async {
    final cacheState = state;

    emit(DepartmentLoading());

    try {
      final response = await _dataSource.addDepartment(event.request);
      emit(
        DepartmentLoaded(response),
      );
    } on APIError catch (error) {
      emit(DepartmentError(message: error.message));

      if (cacheState is DepartmentLoaded) {
        emit(cacheState);
      } else {
        emit(DepartmentLoaded(const []));
      }
    }
  }

  _onPatchDepartmentEvent(PatchDepartmentEvent event, Emitter<DepartmentState> emit) async {
    final cacheState = state;

    emit(DepartmentLoading());

    try {
      final response = await _dataSource.patchDepartment(event.request);

      emit(
        DepartmentLoaded(response),
      );
    } on APIError catch (error) {
      emit(DepartmentError(message: error.message));

      if (cacheState is DepartmentLoaded) {
        emit(cacheState);
      } else {
        emit(DepartmentLoaded(const []));
      }
    }
  }

  _onDeleteDepartmentEvent(DeleteDepartmentEvent event, Emitter<DepartmentState> emit) async {
    final cacheState = state;

    emit(DepartmentLoading());

    try {
      final response = await _dataSource.deleteDepartment(event.request);
      emit(
        DepartmentLoaded(response),
      );
    } on APIError catch (error) {
      emit(DepartmentError(message: error.message));

      if (cacheState is DepartmentLoaded) {
        emit(cacheState);
      } else {
        emit(DepartmentLoaded(const []));
      }
    }
  }

  _onQueryDepartmentEvent(QueryDepartmentEvent event, Emitter<DepartmentState> emit) async {
    final cacheState = state;

    try {
      final response = await _dataSource.getDepartment(
          const GetDepartmentRequest());
      emit(
        DepartmentLoaded(
          response
              .where((element) => element.name.contains(event.searchText))
              .toList(),
        ),
      );
    } on APIError catch (error) {
      emit(DepartmentError(message: error.message));

      if (cacheState is DepartmentLoaded) {
        emit(cacheState);
      } else {
        emit(DepartmentLoaded(const []));
      }
    }
  }
}
