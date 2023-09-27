import 'package:flowerstore/base/ui/textfield/base_textfield.dart';
import 'package:flowerstore/scene/billhistory/presentation/bloc/invoice_bloc.dart';
import 'package:flowerstore/scene/createbill/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/scene/createbill/presentation/bloc/product/product_bloc.dart';
import 'package:flowerstore/scene/dashboard/data/model/customer.dart';
import 'package:flowerstore/scene/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:flowerstore/scene/dashboard/presentation/widget/add_customer_dialog.dart';
import 'package:flowerstore/scene/dashboard/presentation/widget/hotel_item_card.dart';
import 'package:flowerstore/scene/mainmenu/presentation/bloc/mainmenu_bloc.dart';
import 'package:flowerstore/scene/mainmenu/presentation/screen/mainmenu_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? searchText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<DashboardBloc, DashboardState>(
        listener: (context, state) {
          if (state is CustomerPatched) {
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
        builder: (context, state) {
          if (state is DashboardLoaded && state.customers.isNotEmpty) {
            final List<Customer> filteredSearchText = state.customers
                .where((element) => element.name.contains(searchText ?? ""))
                .toList();

            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  BaseTextfield(
                    onTextChange: (text) {
                      setState(() {
                        searchText = text;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        color: Theme.of(context).focusColor,
                        borderRadius: BorderRadius.circular(12)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: TextButton(
                      onPressed: () => openDialog(context),
                      child: Text(
                        "เพิ่มลูกค้า",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemBuilder: (context, position) => HotelItemCard(
                        name: filteredSearchText[position].name,
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (navigatorContext) => MultiBlocProvider(
                              providers: [
                                BlocProvider.value(
                                  value: BlocProvider.of<MainmenuBloc>(context),
                                ),
                                BlocProvider.value(
                                  value:
                                      BlocProvider.of<DashboardBloc>(context),
                                ),
                                BlocProvider.value(
                                  value:
                                  BlocProvider.of<ProductBloc>(context),
                                ),
                                BlocProvider.value(
                                  value:
                                  BlocProvider.of<CategoryBloc>(context),
                                ),
                                BlocProvider.value(
                                  value:
                                  BlocProvider.of<InvoiceBloc>(context),
                                ),
                              ],
                              child: MainMenuScreen(
                                customer: filteredSearchText[position],
                              ),
                            ),
                          ),
                        ),
                      ),
                      itemCount: filteredSearchText.length,
                    ),
                  )
                ],
              ),
            );
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void openDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AddCustomerDialog(
          onSubmit: (request) => BlocProvider.of<DashboardBloc>(context)
              .add(PostCustomersEvent(request)),
        );
      },
    );
  }
}
