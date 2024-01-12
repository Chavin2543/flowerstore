// Flutter imports:
import 'package:flowerstore/data/datasource/customer/model/get_customer_request.dart';
import 'package:flowerstore/data/datasource/department/model/get_department_request.dart';
import 'package:flowerstore/helper/customer_store.dart';
import 'package:flowerstore/presentation/screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

// Project imports:
import 'package:flowerstore/base/ui/textfield/base_textfield.dart';
import 'package:flowerstore/domain/entity/customer.dart';
import 'package:flowerstore/presentation/bloc/customer/customer_bloc.dart';
import 'package:flowerstore/presentation/widget/dialog/add_customer_dialog.dart';
import 'package:flowerstore/presentation/widget/card/hotel_item_card.dart';
import 'package:flowerstore/presentation/screen/mainmenu_screen.dart';
import 'package:flowerstore/presentation/screen/summary_screen.dart';

import '../bloc/analytic/analytic_bloc.dart';
import '../bloc/category/category_bloc.dart';
import '../bloc/department/department_bloc.dart';
import '../bloc/invoice/invoice_bloc.dart';
import '../bloc/product/product_bloc.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String? searchText;

  @override
  void initState() {
    BlocProvider.of<CustomerBloc>(context)
        .add(GetCustomerEvent(request: GetCustomerRequest()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<CustomerBloc, CustomerState>(
          listener: (context, state) {
            if (state is CustomerError) {
              // Handle customer error state
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.message),
                ),
              );
            }
          },
        ),
        BlocListener<ProductBloc, ProductState>(
          listener: (context, state) {
            if (state is ProductError) {
              // Handle customer error state
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.message),
                ),
              );
            }
          },
        ),
        BlocListener<CategoryBloc, CategoryState>(
          listener: (context, state) {
            if (state is CategoryError) {
              // Handle customer error state
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.message),
                ),
              );
            }
          },
        ),
        BlocListener<InvoiceBloc, InvoiceState>(
          listener: (context, state) {
            if (state is InvoiceError) {
              // Handle customer error state
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Error'),
                  content: Text(state.message),
                ),
              );
            }
          },
        ),
        // Add other BlocListeners if you have more BLoCs
      ],
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: _buildCustomerList(),
      ),
    );
  }

  Widget _buildCustomerList() {
    return BlocConsumer<CustomerBloc, CustomerState>(
      listener: (context, state) {
        if (state is CustomerAdded) {
          _showAddedDialog();
        }
      },
      builder: (context, state) {
        if (state is CustomerLoaded && state.customers.isNotEmpty) {
          return _buildCustomerListView(state);
        } else {
          return const LoadingScreen();
        }
      },
    );
  }

  Widget _buildCustomerListView(CustomerLoaded state) {
    final filteredCustomers = state.customers
        .where((customer) => customer.name.contains(searchText ?? ""))
        .toList();

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildActionButtonRow(state.customers),
          const SizedBox(height: 16),
          BaseTextfield(
            onTextChange: (text) => setState(() => searchText = text),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredCustomers.length,
              itemBuilder: (context, index) => HotelItemCard(
                name: filteredCustomers[index].name,
                location: filteredCustomers[index].address,
                onTap: () => _navigateToMainMenu(filteredCustomers[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtonRow(List<Customer> customers) {
    return LayoutBuilder(builder: (context, proxy) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: proxy.maxWidth * 0.4,
            child: Text(
              "ยินดีต้อนรับเข้าสูร้านดอกไม้\nโปรดเลือกลูกค้าที่คุณต้องการ",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          SizedBox(
            width: proxy.maxWidth * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildActionButton("เพิ่มลูกค้า", _openAddCustomerDialog),
                const SizedBox(width: 12),
                _buildActionButton(
                    "สรุปผล", () => _navigateToSummaryScreen(customers)),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildActionButton(String text, VoidCallback onPressed) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Theme.of(context).colorScheme.secondary),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }

  void _openAddCustomerDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) => AddCustomerDialog(
        onSubmit: (request) => BlocProvider.of<CustomerBloc>(context)
            .add(AddCustomerEvent(request: request)),
      ),
    );
  }

  void _navigateToSummaryScreen(List<Customer> customers) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (navigatorContext) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<CustomerBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<ProductBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<CategoryBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<InvoiceBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<AnalyticBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<DepartmentBloc>(context)),
          ],
          child: SummaryScreen(
            customer: customers,
          ),
        ),
      ),
    );
  }

  void _navigateToMainMenu(Customer customer) {
    CustomerStore.setCustomerId(customer.id);
    CustomerStore.setCustomerName(customer.name);

    BlocProvider.of<DepartmentBloc>(context).add(
      GetDepartmentEvent(
        request: const GetDepartmentRequest(),
      ),
    );

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (navigatorContext) => MultiBlocProvider(
          providers: [
            BlocProvider.value(value: BlocProvider.of<CustomerBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<ProductBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<CategoryBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<InvoiceBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<AnalyticBloc>(context)),
            BlocProvider.value(value: BlocProvider.of<DepartmentBloc>(context)),
          ],
          child: MainMenuScreen(customer: customer),
        ),
      ),
    );
  }

  void _showAddedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('สำเร็จ'),
          // You can change this to match your message title
          content: const Text('ลูกค้าถูกเพิ่ม'),
          // Message you want to show
          actions: <Widget>[
            TextButton(
              child: const Text('ตกลง'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
            ),
          ],
        );
      },
    );
  }
}
