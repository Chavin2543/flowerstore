import 'package:flowerstore/scene/billhistory/presentation/bloc/invoice_bloc.dart';
import 'package:flowerstore/scene/billhistory/presentation/screen/bill_history_screen.dart';
import 'package:flowerstore/scene/createbill/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/scene/createbill/presentation/bloc/product/product_bloc.dart';
import 'package:flowerstore/scene/createbill/presentation/screen/createbill_screen.dart';
import 'package:flowerstore/scene/dashboard/data/model/customer.dart';
import 'package:flowerstore/scene/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flowerstore/scene/mainmenu/domain/entity/mainmenu_type.dart';
import 'package:flowerstore/scene/mainmenu/presentation/bloc/mainmenu_bloc.dart';
import 'package:flowerstore/scene/mainmenu/presentation/widget/mainmenu_item.dart';
import 'package:flowerstore/scene/mainmenu/presentation/widget/patch_customer_dialog.dart';
import 'package:flowerstore/scene/manageproduct/presentation/screen/manage_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../widget/delete_confirmation_dialog.dart';

class MainMenuScreen extends StatelessWidget {
  final Customer customer;

  const MainMenuScreen({
    required this.customer,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocListener<MainmenuBloc, MainmenuState>(
      listener: (context, state) {
        if (state is CustomerDeleted) {
          BlocProvider.of<DashboardBloc>(context)
              .add(GetCustomersEvent(DateTime.now()));
          Navigator.of(context).pop();
        } else if (state is CustomerPatched) {
          Fluttertoast.showToast(
            msg: 'ข้อมูลถูกแก้ไขแล้ว',
            // Displayed text
            toastLength: Toast.LENGTH_SHORT,
            // Duration of the toast
            gravity: ToastGravity.BOTTOM,
            // Toast position
            timeInSecForIosWeb: 1,
            // Duration in seconds for iOS and web
            backgroundColor: Colors.black87,
            // Background color of the toast
            textColor: Colors.white,
            // Text color of the toast
            fontSize: 16.0, // Font size
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "${customer.name}",
            style: Theme.of(context).textTheme.displayLarge,
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Row(),
                Container(
                  width: 428,
                  height: 428,
                  child: MainMenuItem(
                    type: MainMenuType.createBill,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (navigatorContext) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: BlocProvider.of<ProductBloc>(context),
                            ),
                            BlocProvider.value(
                              value: BlocProvider.of<CategoryBloc>(context),
                            ),
                          ],
                          child: CreateBillScreen(customer),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: 428,
                  height: 428,
                  child: MainMenuItem(
                    type: MainMenuType.manageBill,
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (navigatorContext) => MultiBlocProvider(
                          providers: [
                            BlocProvider.value(
                              value: BlocProvider.of<InvoiceBloc>(context),
                            ),
                          ],
                          child: BillHistoryScreen(customer),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MainMenuItem(
                      type: MainMenuType.manageFlower,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (navigatorContext) => MultiBlocProvider(
                            providers: [
                              BlocProvider.value(
                                value: BlocProvider.of<ProductBloc>(context),
                              ),
                              BlocProvider.value(
                                value: BlocProvider.of<CategoryBloc>(context),
                              ),
                            ],
                            child: ManageProductScreen(customer),
                          ),
                        ),
                      ),
                    ),
                    MainMenuItem(
                      type: MainMenuType.editCustomer,
                      onTap: () => openDialog(context),
                    ),
                  ],
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    MainMenuItem(
                      type: MainMenuType.deleteCustomer,
                      onTap: () => openConfirmationDialog(context),
                    ),
                    MainMenuItem(
                      type: MainMenuType.report,
                      onTap: () => openConfirmationDialog(context),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return PatchCustomerDialog(
          onSubmit: (request) => BlocProvider.of<MainmenuBloc>(context).add(
            PatchCustomersEvent(customer.id, request),
          ),
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
            BlocProvider.of<MainmenuBloc>(context).add(
              DeleteCustomersEvent(customer.id),
            );
            Navigator.of(context).pop();
          },
        );
      },
    );
  }
}
