import 'package:dio/dio.dart';
import 'package:flowerstore/data/datasource/category/category_datasource.dart';
import 'package:flowerstore/data/datasource/customer/customer_datasource.dart';
import 'package:flowerstore/data/datasource/invoice/invoice_datasource.dart';
import 'package:flowerstore/data/datasource/product/product_datasource.dart';
import 'package:flowerstore/presentation/bloc/analytic/analytic_bloc.dart';
import 'package:flowerstore/presentation/bloc/customer/customer_bloc.dart';
import 'package:flowerstore/presentation/bloc/invoice/invoice_bloc.dart';
import 'package:flowerstore/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/presentation/bloc/product/product_bloc.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.asNewInstance();

Future<void> inject() async {
  // Misc
  injector.registerFactory<Dio>(
    () => Dio.new(BaseOptions(
        baseUrl: "http://numeric-region-387513.as.r.appspot.com/",
        headers: {"api-key": "e5f3f034-44c3-4abe-a6b6-22bdc34cd318"})),
  );
  // DataSources
  injector.registerLazySingleton<CustomerDataSource>(
    () => CustomerDataSourceImpl(
      injector(),
    ),
  );
  injector.registerLazySingleton<ProductDatasource>(
    () => ProductDatasourceImpl(
      injector(),
    ),
  );
  injector.registerLazySingleton<CategoryDataSource>(
    () => CategoryDataSourceImpl(
      injector(),
    ),
  );
  injector.registerLazySingleton<InvoiceDataSource>(
    () => InvoiceDataSourceImpl(
      injector(),
    ),
  );

  // BLoC
  injector.registerFactory(
    () => CustomerBloc(injector()),
  );
  injector.registerFactory(
    () => ProductBloc(injector()),
  );
  injector.registerFactory(
    () => CategoryBloc(injector()),
  );
  injector.registerFactory(
    () => InvoiceBloc(injector(), injector()),
  );
  injector.registerFactory(
    () => AnalyticBloc(injector()),
  );
}
