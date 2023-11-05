import 'package:flowerstore/data/datasource/invoice/model/request/add_invoice_request.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/patch_invoice_request.dart';
import 'package:flowerstore/helper/customer_store.dart';
import 'package:flowerstore/presentation/screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowerstore/data/datasource/category/model/request/get_category_request.dart';
import 'package:flowerstore/data/datasource/product/model/get_product_request.dart';
import 'package:flowerstore/domain/entity/bill_item.dart';
import 'package:flowerstore/domain/entity/customer.dart';
import 'package:flowerstore/domain/entity/product.dart';
import 'package:flowerstore/presentation/bloc/invoice/invoice_bloc.dart';
import 'package:flowerstore/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/presentation/bloc/product/product_bloc.dart';
import 'package:flowerstore/presentation/widget/section/bill_summary.dart';
import 'package:flowerstore/presentation/screen/print_screen.dart';
import 'package:flowerstore/presentation/widget/dialog/custom_product_dialog.dart';
import 'package:flowerstore/presentation/widget/item/createbill_item.dart';
import 'package:flowerstore/presentation/widget/section/prefill_item_section.dart';

class CreateBillScreen extends StatefulWidget {
  final int? invoiceId;
  final Customer customer;

  const CreateBillScreen(this.customer, {Key? key, this.invoiceId})
      : super(key: key);

  @override
  CreateBillScreenState createState() => CreateBillScreenState();
}

class CreateBillScreenState extends State<CreateBillScreen> {
  List<BillItem> currentBillItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  Future<void> _initializeData() async {
    BlocProvider.of<CategoryBloc>(context)
        .add(GetCategoriesEvent(request: const GetCategoryRequest()));
    BlocProvider.of<ProductBloc>(context)
        .add(GetProductEvent(request: GetProductRequest()));

    if (widget.invoiceId != null) {
      currentBillItems = await BlocProvider.of<InvoiceBloc>(context)
          .getInitialInvoiceItem(widget.invoiceId!);
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text("สร้างบิล", style: Theme.of(context).textTheme.displayLarge),
        actions: [_buildRefreshButton()],
      ),
      body: isLoading ? _buildLoadingIndicator() : _buildBillScreenBody(),
    );
  }

  IconButton _buildRefreshButton() {
    return IconButton(
      onPressed: _initializeData,
      icon: const Icon(Icons.refresh),
    );
  }

  Widget _buildLoadingIndicator() {
    return const LoadingScreen();
  }

  SingleChildScrollView _buildBillScreenBody() {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Column(
        children: [
          _buildPrefillItemSection(),
          _buildBillItemList(),
          _buildBillSummary()
        ],
      ),
    );
  }

  PrefillItemSection _buildPrefillItemSection() {
    return PrefillItemSection(
      onTap: openCustomProductDialog,
      customerId: widget.customer.id,
    );
  }

  SizedBox _buildBillItemList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.4,
      child: ReorderableListView(
        onReorder: _onReorder,
        children: _buildBillItemWidgets(),
      ),
    );
  }

  List<Widget> _buildBillItemWidgets() {
    return currentBillItems.map((item) {
      return CreateBillItem(
        key: Key(item.product.id.toString()),
        product: item.product,
        quantity: item.quantity,
        onDelete: () => deleteBillByProduct(item),
        onDecrease: () => deductBillByProduct(item),
        onIncrease: () => addBillByProduct(item),
      );
    }).toList();
  }

  BillSummary _buildBillSummary() {
    return BillSummary(
      total: currentBillItems.fold(
          0, (total, item) => total + item.product.price * item.quantity),
      onContinue: _handleContinue,
    );
  }

  void _handleContinue() async {
    final selectedDepartment = await _showDepartmentSelectionDialog();
    if (selectedDepartment != null) {
      _navigateToPrintScreen();
    }
  }

  Future<String?> _showDepartmentSelectionDialog() {
    return showDialog<String>(
      context: context,
      builder: (navigatorContext) =>
          _buildDepartmentSelectionDialog(navigatorContext),
    );
  }

  AlertDialog _buildDepartmentSelectionDialog(BuildContext navigatorContext) {
    return AlertDialog(
      title: const Text('เลือกแผนก'),
      content: _buildDepartmentDropdown(),
      actions: _buildDialogActions(navigatorContext),
    );
  }

  DropdownButton<String> _buildDepartmentDropdown() {
    const departments = ['HR', 'Engineering', 'Marketing', 'Sales'];
    String? selectedDepartment = departments.first;

    return DropdownButton<String>(
      isExpanded: true,
      value: selectedDepartment,
      items: departments
          .map((value) =>
              DropdownMenuItem<String>(value: value, child: Text(value)))
          .toList(),
      onChanged: (value) => setState(() => selectedDepartment = value),
    );
  }

  List<Widget> _buildDialogActions(BuildContext navigatorContext) {
    return [
      ElevatedButton(
        onPressed: () => _completeDepartmentSelection(navigatorContext),
        child: const Text('ต่อไป'),
      ),
      ElevatedButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('ยกเลิก'),
      ),
    ];
  }

  void _completeDepartmentSelection(BuildContext navigatorContext) {
    Navigator.of(navigatorContext).pop();
    _navigateToPrintScreen();
  }

  void _navigateToPrintScreen() {
    final customerId = CustomerStore.getCustomerId();
    final total = currentBillItems.total;
    final invoiceId = widget.invoiceId;

    if (customerId != null) {
      if (invoiceId != null) {
        BlocProvider.of<InvoiceBloc>(context).add(
          PatchInvoiceEvent(
            request: PatchInvoiceRequest(
              total: total,
              customerId: customerId,
              invoiceId: invoiceId,
              currentBillItem: currentBillItems
            ),
          ),
        );
      } else {
        BlocProvider.of<InvoiceBloc>(context).add(
          AddInvoicesEvent(
            request: AddInvoiceRequest(
              total: total,
              customerId: customerId,
              billItems: currentBillItems,
            ),
          ),
        );
      }

      Navigator.of(context).push(MaterialPageRoute(
        builder: (navigatorContext2) =>
            PrintScreen(billItems: currentBillItems, customer: widget.customer),
      ));
    }
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) newIndex -= 1;
      final BillItem item = currentBillItems.removeAt(oldIndex);
      currentBillItems.insert(newIndex, item);
    });
  }

  void addBillByProduct(BillItem targetProduct, [int? quantity]) {
    setState(() {
      currentBillItems = currentBillItems.map((billItem) {
        if (billItem.product.id == targetProduct.product.id) {
          final newQuantity = billItem.quantity + (quantity ?? 1);
          return billItem.copyWith(quantity: newQuantity);
        }
        return billItem;
      }).toList();
    });
  }

  void deductBillByProduct(BillItem targetProduct, [int? quantity]) {
    setState(() {
      currentBillItems = currentBillItems
          .map((billItem) {
            if (billItem.product.id == targetProduct.product.id &&
                billItem.quantity > 0) {
              final newQuantity = billItem.quantity - (quantity ?? 1);
              return billItem.copyWith(quantity: newQuantity);
            }
            return billItem;
          })
          .where((billItem) => billItem.quantity > 0)
          .toList();
    });
  }

  void deleteBillByProduct(BillItem targetProduct) {
    setState(() => currentBillItems.removeWhere(
        (billItem) => billItem.product.id == targetProduct.product.id));
  }

  void openCustomProductDialog(Product product) {
    showDialog(
      context: context,
      builder: (dialogContext) => CustomProductDialog(
        product: product,
        onSubmit: (BillItem billItem) =>
            _handleCustomProductDialogSubmit(product, billItem),
      ),
    );
  }

  void _handleCustomProductDialogSubmit(Product product, BillItem billItem) {
    if (currentBillItems
            .indexWhere((element) => element.product.id == product.id) ==
        -1) {
      setState(() => currentBillItems.add(billItem));
    } else {
      addBillByProduct(billItem, billItem.quantity);
    }
  }
}
