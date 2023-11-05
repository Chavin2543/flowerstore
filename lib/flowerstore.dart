import 'package:flowerstore/base/app_theme.dart';
import 'package:flowerstore/presentation/bloc/analytic/analytic_bloc.dart';
import 'package:flowerstore/presentation/bloc/customer/customer_bloc.dart';
import 'package:flowerstore/presentation/bloc/invoice/invoice_bloc.dart';
import 'package:flowerstore/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/presentation/bloc/product/product_bloc.dart';
import 'package:flowerstore/presentation/screen/dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowerstore/base/dependency_injector.dart' as di;

class FlowerStore extends StatelessWidget {
  const FlowerStore({Key? key}) : super(key: key);

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
        ],
        child: const DashboardScreen(),
      ),
    );
  }
}
