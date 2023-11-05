// Dart imports:
import 'package:flowerstore/data/api_error.dart';
import 'package:flowerstore/presentation/bloc/category/category_bloc.dart';
import 'package:meta/meta.dart';

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Project imports:
import 'package:flowerstore/data/datasource/customer/customer_datasource.dart';
import '../../../data/datasource/customer/model/add_customer_request.dart';
import '../../../data/datasource/customer/model/delete_customer_request.dart';
import '../../../data/datasource/customer/model/get_customer_request.dart';
import '../../../data/datasource/customer/model/patch_customer_request.dart';
import '../../../domain/entity/customer.dart';

// Part files:
part 'customer_event.dart';
part 'customer_state.dart';


class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final CustomerDataSource _dataSource;

  CustomerBloc(this._dataSource) : super(CustomerInitial()) {
    on<GetCustomerEvent>((event, emit) async => _onGetCustomerEvent(event, emit));
    on<AddCustomerEvent>((event, emit) async => _onAddCustomerEvent(event, emit));
    on<PatchCustomerEvent>((event, emit) async => _onUpdateCustomerEvent(event, emit));
    on<DeleteCustomerEvent>((event, emit) async => _onDeleteCustomerEvent(event, emit));
  }

  _onGetCustomerEvent(GetCustomerEvent event, Emitter<CustomerState> emit) async {
    final cacheState = state;

    emit(CustomerLoading());

    try {
      final response = await _dataSource.getCustomer(event.request);

      emit(CustomerLoaded(customers: response));
    } on APIError catch (error) {
      emit(CustomerError(message: error.message));

      if (cacheState is CustomerLoaded) {
        emit(cacheState);
      } else {
        emit(const CustomerLoaded(customers: []));
      }
    }
  }

  _onAddCustomerEvent(AddCustomerEvent event, Emitter<CustomerState> emit) async {
    final cacheState = state;

    emit(CustomerLoading());

    try {
      final response = await _dataSource.addCustomer(event.request);
      emit(CustomerAdded());
      emit(CustomerLoaded(customers: response));
    } on APIError catch (error) {
      emit(CustomerError(message: error.message));

      if (cacheState is CustomerLoaded) {
        emit(cacheState);
      } else {
        emit(const CustomerLoaded(customers: []));
      }
    }
  }

  _onUpdateCustomerEvent(PatchCustomerEvent event, Emitter<CustomerState> emit) async {
    final cacheState = state;

    emit(CustomerLoading());

    try {
      await _dataSource.patchCustomer(event.request);

      final response = await _dataSource.getCustomer(GetCustomerRequest());

      emit(CustomerPatched());
      emit(CustomerLoaded(customers: response));
    } on APIError catch (error) {
      emit(CustomerError(message: error.message));

      if (cacheState is CustomerLoaded) {
        emit(cacheState);
      } else {
        emit(const CustomerLoaded(customers: []));
      }
    }
  }

  _onDeleteCustomerEvent(DeleteCustomerEvent event, Emitter<CustomerState> emit) async {
    final cacheState = state;

    emit(CustomerLoading());

    try {
      await _dataSource.deleteCustomer(event.request);

      final response = await _dataSource.getCustomer(GetCustomerRequest());

      emit(CustomerDeleted());
      emit(CustomerLoaded(customers: response));
    } on APIError catch (error) {
      emit(CustomerError(message: error.message));

      if (cacheState is CustomerLoaded) {
        emit(cacheState);
      } else {
        emit(const CustomerLoaded(customers: []));
      }
    }
  }
}
