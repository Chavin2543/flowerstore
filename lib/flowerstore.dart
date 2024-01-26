import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flowerstore/base/app_theme.dart';
import 'package:flowerstore/presentation/bloc/analytic/analytic_bloc.dart';
import 'package:flowerstore/presentation/bloc/customer/customer_bloc.dart';
import 'package:flowerstore/presentation/bloc/department/department_bloc.dart';
import 'package:flowerstore/presentation/bloc/invoice/invoice_bloc.dart';
import 'package:flowerstore/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/presentation/bloc/product/product_bloc.dart';
import 'package:flowerstore/presentation/screen/dashboard/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowerstore/base/dependency_injector.dart' as di;
import 'package:updat/updat.dart';
import 'dart:convert';

class FlowerStore extends StatelessWidget {
  const FlowerStore({required this.version, Key? key}) : super(key: key);

  final String version;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<CustomerBloc>(
            create: (context) => di.injector<CustomerBloc>(),
          ),
          BlocProvider<ProductBloc>(
            create: (context) => di.injector<ProductBloc>(),
          ),
          BlocProvider<CategoryBloc>(
            create: (context) => di.injector<CategoryBloc>(),
          ),
          BlocProvider<InvoiceBloc>(
            create: (context) => di.injector<InvoiceBloc>(),
          ),
          BlocProvider<AnalyticBloc>(
            create: (context) => di.injector<AnalyticBloc>(),
          ),
          BlocProvider<DepartmentBloc>(
            create: (context) => di.injector<DepartmentBloc>(),
          ),
        ],
        child: Stack(
          children: [
            UpdatWidget(
                currentVersion: version,
                getLatestVersion: () async {
                  final dio = Dio();
                  final response = await dio.get(
                      "https://api.github.com/repos/Chavin2543/flowerstore/releases/latest");
                  return jsonDecode(response.data)["tag_name"];
                },
                getBinaryUrl: (version) async {
                  // Update or remove this depending on your release assets
                  return "https://github.com/Chavin2543/flowerstore/releases/download/$version/your-binary-file-name";
                },
                appName: "FlowerStore",
                getChangelog: (_, __) async {
                  final dio = Dio();
                  final response = await dio.get(
                      "https://api.github.com/repos/Chavin2543/flowerstore/releases/latest");
                  return jsonDecode(response.data)["body"];
                }),
            const DashboardScreen(),
          ],
        ),
      ),
    );
  }
}
