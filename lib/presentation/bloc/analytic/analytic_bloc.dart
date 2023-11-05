// Dart imports:

// Package imports:
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowerstore/data/api_error.dart';
import 'package:flowerstore/data/datasource/invoice/invoice_datasource.dart';
import 'package:meta/meta.dart';

// Project imports:
import 'package:flowerstore/data/datasource/product/product_datasource.dart';

import '../../../data/datasource/invoice/model/request/get_invoice_request.dart';
import '../../../domain/entity/invoice.dart';

// Part files:
part 'analytic_event.dart';

part 'analytic_state.dart';

class AnalyticBloc extends Bloc<AnalyticEvent, AnalyticState> {
  final InvoiceDataSource _dataSource;

  AnalyticBloc(this._dataSource)
      : super(AnalyticInitial()) {
    on<GetAnalyticsEvent>(
        (event, emit) async => _onGetAnalyticsEvent(event, emit));
  }

  _onGetAnalyticsEvent(
      GetAnalyticsEvent event, Emitter<AnalyticState> emit) async {
    final cacheState = state;

    emit(AnalyticLoading());

    try {
      final response = await _dataSource.getInvoice(event.request);

      emit(AnalyticLoaded(response));
    } on APIError catch (error) {
      emit(AnalyticError(message: error.message));

      if (cacheState is AnalyticLoaded) {
        emit(cacheState);
      } else {
        emit(AnalyticLoaded(const []));
      }
    }
  }
}
