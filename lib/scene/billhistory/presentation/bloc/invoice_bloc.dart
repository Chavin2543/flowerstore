import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flowerstore/scene/billhistory/datasource/invoice_remote_datasource.dart';
import 'package:flowerstore/scene/billhistory/model/invoice.dart';
import 'package:meta/meta.dart';

import '../../model/add_invoice.dart';
import '../../model/patch_invoice.dart';

part 'invoice_event.dart';

part 'invoice_state.dart';

class InvoiceBloc extends Bloc<InvoiceEvent, InvoiceState> {
  final InvoiceRemoteDataSource _dataSource;

  InvoiceBloc(this._dataSource) : super(InvoiceInitial()) {
    on<GetInvoicesEvent>(
        (event, emit) async => _onGetInvoicesEvent(event, emit));
    on<PostInvoicesEvent>(
        (event, emit) async => _onPostInvoiceEvent(event, emit));
    on<QueryInvoiceEvent>(
        (event, emit) async => _onQueryInvoiceEvent(event, emit));
  }

  _onGetInvoicesEvent(
      GetInvoicesEvent event, Emitter<InvoiceState> emit) async {
    final response = await _dataSource.getInvoice();
    emit(InvoiceLoaded(response));
  }

  _onPostInvoiceEvent(
      PostInvoicesEvent event, Emitter<InvoiceState> emit) async {
    final response = await _dataSource.postInvoice(event.request);
    emit(InvoiceLoaded(response));
  }

  _onQueryInvoiceEvent(
      QueryInvoiceEvent event, Emitter<InvoiceState> emit) async {
    final response = await _dataSource.getInvoiceById(event.customerId);
    emit(InvoiceLoaded(response));
  }
}
