import 'package:flowerstore/base/app_theme.dart';
import 'package:flowerstore/scene/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flowerstore/scene/dashboard/presentation/screen/dashboard_screen.dart';
import 'package:flowerstore/scene/mainmenu/presentation/bloc/mainmenu_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowerstore/base/dependency_injector.dart' as di;

class FlowerStore extends StatelessWidget {
  FlowerStore({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<DashboardBloc>(
            create: (context) => di.injector<DashboardBloc>(),
          ),
          BlocProvider<MainmenuBloc>(
            create: (context) => di.injector<MainmenuBloc>(),
          ),
        ],
        child: const DashboardScreen(),
      ),
    );
  }
}
