import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowerstore/scene/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:flowerstore/scene/dashboard/data/model/add_customer.dart';
import 'package:flowerstore/scene/dashboard/data/model/customer.dart';
import 'package:flowerstore/scene/dashboard/data/model/patch_customer.dart';
import 'package:meta/meta.dart';

part 'dashboard_event.dart';

part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final DashboardRemoteDataSource _dataSource;

  DashboardBloc(this._dataSource) : super(DashboardInitial()) {
    on<GetCustomersEvent>((event, emit) => _onGetCustomersEvent(event, emit));
    on<PostCustomersEvent>((event, emit) => _onPostCustomersEvent(event, emit));

    add(GetCustomersEvent(DateTime.now()));
  }

  _onGetCustomersEvent(
      GetCustomersEvent event, Emitter<DashboardState> emit) async {
    final response = await _dataSource.getCustomers();
    emit(DashboardLoaded(response));
  }

  _onPostCustomersEvent(
    PostCustomersEvent event,
    Emitter<DashboardState> emit,
  ) async {
    final response = await _dataSource.postCustomers(event.request);
    emit(DashboardLoaded(response));
  }
}
