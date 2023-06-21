import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../dashboard/data/datasource/dashboard_remote_datasource.dart';
import '../../../dashboard/data/model/add_customer.dart';
import '../../../dashboard/data/model/patch_customer.dart';

part 'mainmenu_event.dart';

part 'mainmenu_state.dart';

class MainmenuBloc extends Bloc<MainmenuEvent, MainmenuState> {
  final DashboardRemoteDataSource _dataSource;

  MainmenuBloc(
    this._dataSource,
  ) : super(MainmenuInitial()) {
    on<DeleteCustomersEvent>(
        (event, emit) => _deleteCustomerEvent(event, emit));
    on<PatchCustomersEvent>(
            (event, emit) => _onPatchCustomersEvent(event, emit));
  }

  _deleteCustomerEvent(
    DeleteCustomersEvent event,
    Emitter<MainmenuState> emit,
  ) async {
    await _dataSource.deleteCustomers(event.id);
    emit(CustomerDeleted());
  }

  _onPatchCustomersEvent(
      PatchCustomersEvent event,
      Emitter<MainmenuState> emit,
      ) async {
    await _dataSource.patchCustomers(event.id, event.request);
    emit(CustomerPatched());
  }
}
