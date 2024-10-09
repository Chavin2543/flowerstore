import 'package:flowerstore/data/datasource/customer/model/get_customer_request.dart';
import 'package:flowerstore/presentation/screen/mainmenu/mainmenu_dialog.dart';
import 'package:flowerstore/presentation/screen/mainmenu/mainmenu_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Project imports:
import '../../../domain/entity/customer.dart';
import '../../../domain/entity/mainmenu_type.dart';
import '../../bloc/customer/customer_bloc.dart';
import '../../bloc/invoice/invoice_bloc.dart';
import '../../widget/item/mainmenu_item.dart';

class MainMenuScreen extends StatelessWidget {
  final Customer customer;

  const MainMenuScreen({
    required this.customer,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final largeButtonWidth = screenWidth * 0.25;
    final smallButtonWidth = screenWidth * 0.16;

    return BlocListener<CustomerBloc, CustomerState>(
      listener: (context, state) {
        if (state is CustomerDeleted) {
          BlocProvider.of<CustomerBloc>(context)
              .add(GetCustomerEvent(request: GetCustomerRequest()));
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title:
              Text(customer.name, style: Theme.of(context).textTheme.bodyLarge),
        ),
        body: SingleChildScrollView(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Spacer(),
                _buildMenuItem(
                    context,
                    MainMenuType.createBill,
                    () async => openCreateBillConfirmationDialog(
                        context,
                        await BlocProvider.of<InvoiceBloc>(context)
                            .generateInvoiceId()),
                    largeButtonWidth),
                _buildMenuItem(
                    context,
                    MainMenuType.manageBill,
                    () => navigateToBillHistoryScreen(context),
                    largeButtonWidth),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuItem(
                        context,
                        MainMenuType.manageFlower,
                        () => navigateToManageProductScreen(context),
                        smallButtonWidth),
                    _buildMenuItem(
                      context,
                      MainMenuType.editCustomer,
                      () => openEditCustomerDialog(
                        context,
                        customer,
                      ),
                      smallButtonWidth,
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuItem(
                        context,
                        MainMenuType.deleteCustomer,
                        () => openConfirmationDialog(context),
                        smallButtonWidth),
                    _buildMenuItem(
                        context,
                        MainMenuType.report,
                        () => navigateToAnalyticScreen(context),
                        smallButtonWidth),
                  ],
                ),
                BlocListener<CustomerBloc, CustomerState>(
                  listener: (context, state) {
                    if (state is CustomerPatched) {
                      Fluttertoast.showToast(
                          msg: "ข้อมูลได้ถูกแก้แล้ว โปรดเข้าใหม่");
                      Navigator.pop(context);
                    }
                  },
                  child: Container(),
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, MainMenuType type,
      VoidCallback onTap, double width) {
    double height = width;
    return SizedBox(
      width: width,
      height: height,
      child: MainMenuItem(
        type: type,
        onTap: onTap,
      ),
    );
  }
}
