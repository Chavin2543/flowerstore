import 'package:dio/dio.dart';
import 'package:flowerstore/scene/createbill/data/datasource/category_remote_datasource.dart';
import 'package:flowerstore/scene/createbill/data/datasource/product_remote_datasource.dart';
import 'package:flowerstore/scene/createbill/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/scene/createbill/presentation/bloc/product/product_bloc.dart';
import 'package:flowerstore/scene/dashboard/data/datasource/dashboard_remote_datasource.dart';
import 'package:flowerstore/scene/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flowerstore/scene/mainmenu/presentation/bloc/mainmenu_bloc.dart';
import 'package:get_it/get_it.dart';

final injector = GetIt.asNewInstance();

Future<void> inject() async {
  // Misc
  injector.registerFactory<Dio>(
    () => Dio.new(
        BaseOptions(baseUrl: "http://numeric-region-387513.as.r.appspot.com/")),
  );
  // DataSources
  injector.registerLazySingleton<DashboardRemoteDataSource>(
    () => DashboardRemoteDataSourceImpl(
      injector(),
    ),
  );
  injector.registerLazySingleton<ProductRemoteDataSource>(
    () => ProductRemoteDataSourceImpl(
      injector(),
    ),
  );
  injector.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(
      injector(),
    ),
  );

  // BLoC
  injector.registerFactory(
    () => DashboardBloc(
      injector(),
    ),
  );
  injector.registerFactory(
    () => MainmenuBloc(
      injector(),
    ),
  );
  injector.registerFactory(
    () => ProductBloc(),
  );
  injector.registerFactory(
    () => CategoryBloc(),
  );
}
