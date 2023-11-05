import 'package:flowerstore/data/datasource/customer/model/delete_customer_request.dart';
import 'package:flowerstore/data/datasource/customer/model/get_customer_request.dart';
import 'package:flowerstore/data/datasource/customer/model/patch_customer_request.dart';
import 'package:flowerstore/helper/customer_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Project imports:
import '../../domain/entity/customer.dart';
import '../../domain/entity/mainmenu_type.dart';
import '../bloc/analytic/analytic_bloc.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/customer/customer_bloc.dart';
import '../bloc/invoice/invoice_bloc.dart';
import '../bloc/product/product_bloc.dart';
import '../screen/analytic_screen.dart';
import '../screen/bill_history_screen.dart';
import '../screen/createbill_screen.dart';
import '../screen/manage_product_screen.dart';
import '../widget/dialog/delete_confirmation_dialog.dart';
import '../widget/dialog/patch_customer_dialog.dart';
import '../widget/item/mainmenu_item.dart';

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
        } else if (state is CustomerPatched) {
          _showPatchToast(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(customer.name,
              style: Theme.of(context).textTheme.displayLarge),
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
                    () => _navigateToCreateBillScreen(context),
                    largeButtonWidth),
                _buildMenuItem(
                    context,
                    MainMenuType.manageBill,
                    () => _navigateToBillHistoryScreen(context),
                    largeButtonWidth),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildMenuItem(
                        context,
                        MainMenuType.manageFlower,
                        () => _navigateToManageProductScreen(context),
                        smallButtonWidth),
                    _buildMenuItem(context, MainMenuType.editCustomer,
                        () => openDialog(context, customer), smallButtonWidth),
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
                        () => _navigateToAnalyticScreen(context),
                        smallButtonWidth),
                  ],
                ),
                BlocListener<CustomerBloc, CustomerState>(
                  listener: (context, state) {
                    if (state is CustomerPatched) {
                      Fluttertoast.showToast(msg: "ข้อมูลได้ถูกแก้แล้ว โปรดเข้าใหม่");
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

  void _navigateToCreateBillScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (navigatorContext) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<CustomerBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<ProductBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<CategoryBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<InvoiceBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<AnalyticBloc>(context)),
          ],
          child: CreateBillScreen(customer, invoiceId: null),
        ),
      ),
    );
  }

  void _navigateToBillHistoryScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (navigatorContext) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<CustomerBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<ProductBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<CategoryBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<InvoiceBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<AnalyticBloc>(context)),
          ],
          child: BillHistoryScreen(customer),
        ),
      ),
    );
  }

  void _navigateToManageProductScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (navigatorContext) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<CustomerBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<ProductBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<CategoryBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<InvoiceBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<AnalyticBloc>(context)),
          ],
          child: ManageProductScreen(customer),
        ),
      ),
    );
  }

  void _navigateToAnalyticScreen(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (navigatorContext) => AnalyticScreen()),
    );
  }

  void openDialog(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return PatchCustomerDialog(
          onSubmit: (request) {
            final customerId = CustomerStore.getCustomerId();
            if (customerId != null) {
              BlocProvider.of<CustomerBloc>(context)
                  .add(PatchCustomerEvent(request: request));
            }
          },
          initialAddress: customer.address,
          initialName: customer.name,
          initialPhone: customer.phone,
        );
      },
    );
  }

  void openConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return DeleteConfirmationDialog(
          message: 'ยืนยันว่าจะลบลูกค้าท่านนี้',
          onConfirm: () {
            final customerId = CustomerStore.getCustomerId();

            if (customerId != null) {
              BlocProvider.of<CustomerBloc>(context).add(DeleteCustomerEvent(
                  request: DeleteCustomerRequest(customerId: customerId)));
            }

            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _showPatchToast(BuildContext context) {
    Fluttertoast.showToast(
      msg: 'ข้อมูลถูกแก้ไขแล้ว',
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
}
