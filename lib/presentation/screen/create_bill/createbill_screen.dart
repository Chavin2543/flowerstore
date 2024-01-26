import 'package:flowerstore/data/datasource/invoice/model/request/add_invoice_request.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/get_invoice_request.dart';
import 'package:flowerstore/data/datasource/invoice/model/request/patch_invoice_request.dart';
import 'package:flowerstore/domain/entity/biller.dart';
import 'package:flowerstore/helper/customer_store.dart';
import 'package:flowerstore/presentation/screen/loading_screen.dart';
import 'package:flowerstore/presentation/widget/dialog/department_selection_dialog.dart';
import 'package:flowerstore/presentation/widget/dialog/discount_dialog.dart';
import 'package:flowerstore/presentation/widget/dialog/error_dialog/core_error_dialog.dart';
import 'package:flowerstore/presentation/widget/dialog/input_dialog/core_four_input_dialog.dart';
import 'package:flowerstore/presentation/widget/dialog/selection_dialog/core_selection_dialog.dart';
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
import 'package:flowerstore/presentation/screen/print/print_screen.dart';
import 'package:flowerstore/presentation/widget/item/createbill_item.dart';
import 'package:flowerstore/presentation/widget/section/prefill_item_section.dart';
import '../../../domain/entity/invoice.dart';
import '../../bloc/department/department_bloc.dart';

class CreateBillScreen extends StatefulWidget {
  final Invoice? invoice;
  final int displayInvoiceId;
  final Customer customer;

  const CreateBillScreen(
    this.customer, {
    Key? key,
    this.invoice,
    required this.displayInvoiceId,
  }) : super(key: key);

  @override
  CreateBillScreenState createState() => CreateBillScreenState();
}

class CreateBillScreenState extends State<CreateBillScreen> {
  List<BillItem> currentBillItems = [];
  bool isLoading = true;
  int currentInvoiceId = 0;

  @override
  void initState() {
    _initializeData();
    super.initState();
  }

  Future<void> _initializeData() async {
    BlocProvider.of<CategoryBloc>(context).add(
      GetCategoriesEvent(
        request: const GetCategoryRequest(),
      ),
    );
    BlocProvider.of<ProductBloc>(context).add(
      GetProductEvent(
        request: GetProductRequest(),
      ),
    );
    BlocProvider.of<InvoiceBloc>(context).add(
      GetInvoicesEvent(
        request: GetInvoiceRequest(),
        shouldFilter: true,
      ),
    );
    if (widget.invoice?.id != null) {
      currentBillItems =
          await BlocProvider.of<InvoiceBloc>(context).getInitialInvoiceItem(
        widget.invoice!.id!,
      );
      currentInvoiceId = widget.invoice!.id;
    } else {
      final customerId = CustomerStore.getCustomerId();
      if (customerId != null) {
        BlocProvider.of<InvoiceBloc>(context).add(
          AddInvoicesEvent(
            request: AddInvoiceRequest(
              total: 0,
              customerId: customerId,
              invoiceId: widget.displayInvoiceId,
              billItems: [],
            ),
          ),
        );
      }
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "สร้างบิลที่ ${widget.displayInvoiceId} ของ ${CustomerStore.getCustomerName()}",
            style: Theme.of(context).textTheme.bodyLarge),
        actions: [
          _buildRefreshButton(),
        ],
      ),
      body: BlocListener<InvoiceBloc, InvoiceState>(
        listener: (context, state) {
          if (state is InvoiceCreated) {
            currentInvoiceId = state.invoiceId;
          }
        },
        child: isLoading ? _buildLoadingIndicator() : _buildBillScreenBody(),
      ),
    );
  }
}

extension CreateBillNavigation on CreateBillScreenState {
  void _navigateToPrintScreen(int selectedDepartment, String selectedCompany,
      DiscountResult discount) {
    final customerId = CustomerStore.getCustomerId();
    final total = currentBillItems.total;
    final invoiceId = currentInvoiceId;
    if (total == 0) {
      showProductsNotAddedDialog();
      return;
    }
    if (customerId != null) {
      BlocProvider.of<InvoiceBloc>(context).add(
        PatchInvoiceEvent(
          request: PatchInvoiceRequest(
            total: total,
            customerId: customerId,
            currentBillItem: currentBillItems,
            invoiceId: invoiceId,
            displayInvoiceId: widget.displayInvoiceId,
            discount: discount.discount,
            discountedTotal: discount.discountedTotal,
            department: selectedDepartment,
            biller: selectedCompany,
          ),
        ),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (navigatorContext2) => PrintScreen(
            billItems: currentBillItems,
            customer: widget.customer,
            company: selectedCompany,
            department: selectedDepartment,
          ),
        ),
      );
    }
  }
}

extension CreateBillUIBuilder on CreateBillScreenState {
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
        onChangePrice: (double newPrice) =>
            {changePriceByProduct(item, newPrice)},
        onChangeQuantity: (int newQuantity) =>
            {changeQuantityByProduct(item, newQuantity)},
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
}

extension CreateBillDialog on CreateBillScreenState {
  void showProductsNotAddedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return const CoreErrorDialog(
          title: "แจ้งเตือน",
          message: "โปรดใส่สินค้าอย่างน้อย 1 ชิ้น",
          buttonTitle: "ตกลง",
        );
      },
    );
  }

  Future<int?> showDepartmentSelectionDialog() {
    return showDialog<int>(
        context: context,
        builder: (navigatorContext) => MultiBlocProvider(
              providers: [
                BlocProvider.value(
                    value: BlocProvider.of<DepartmentBloc>(context)),
              ],
              child: DepartmentSelectionDialog(
                onSelect: (int department) {
                  Navigator.of(navigatorContext).pop(department);
                },
                selectedDepartment: widget.invoice?.departmentId,
              ),
            ));
  }

  Future<DiscountResult?> showDiscountDialog() {
    return showDialog<DiscountResult>(
      context: context,
      builder: (navigatorContext) => DiscountDialog(
        total: currentBillItems.total,
        onSubmit: (result) {
          Navigator.of(navigatorContext).pop(result);
        },
        oldDiscount: widget.invoice?.discount ?? 0.0,
      ),
    );
  }

  Future<String?> showCompanySelectionDialog() {
    return showDialog<String>(
      context: context,
      builder: (navigatorContext) => CoreSelectionDialog(
        onSelect: (String biller) {
          Navigator.of(navigatorContext).pop(biller);
        },
        items: allBillerNames,
        existingSelection: widget.invoice?.biller,
      ),
    );
  }

  void openCustomProductDialog(Product product) {
    showDialog(
      context: context,
      builder: (dialogContext) => CoreFourInputDialog(
        onSubmit: (response) {
          BillItem billItem = BillItem(
            product: Product(
              id: product.id,
              name: response.input1,
              categoryId: product.categoryId,
              customerId: product.customerId,
              price: double.parse(response.input2),
              unit: response.input4,
            ),
            quantity: int.parse(response.input3),
          );
          _handleCustomProductDialogSubmit(
            product,
            billItem,
          );
        },
        title: "เพิ่มสินค้า",
        input1Placeholder: "ชื่อสินค้า",
        prefillInput1: product.name,
        input2Placeholder: "ราคา",
        prefillInput2: product.price.toString(),
        input3Placeholder: "จำนวน",
        input4Placeholder: "หน่วย",
        prefillInput4: product.unit,
        primaryButtonTitle: "เพิ่ม",
        secondaryButtonTitle: "ยกเลิก",
        autoFocusPosition: FourAutoFocusPosition.three,
      ),
    );
  }

  void _handleCustomProductDialogSubmit(Product product, BillItem billItem) {
    if (currentBillItems
            .indexWhere((element) => element.product.id == product.id) ==
        -1) {
      setState(
        () => currentBillItems.add(billItem),
      );
    } else {
      addBillByProduct(billItem, billItem.quantity);
    }
  }
}

extension CreateBillAction on CreateBillScreenState {
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

  void changePriceByProduct(BillItem targetProduct, double newPrice) {
    setState(() {
      currentBillItems = currentBillItems.map((billItem) {
        if (billItem.product.id == targetProduct.product.id) {
          return billItem.copyWith(
              product: targetProduct.product.copyWith(price: newPrice));
        }
        return billItem;
      }).toList();
    });
  }

  void changeQuantityByProduct(BillItem targetProduct, int newQuantity) {
    setState(() {
      currentBillItems = currentBillItems.map((billItem) {
        if (billItem.product.id == targetProduct.product.id) {
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

  void _handleContinue() async {
    final discount = await showDiscountDialog();
    final selectedDepartment = await showDepartmentSelectionDialog();
    final selectedCompany = await showCompanySelectionDialog();
    if (selectedDepartment != null &&
        selectedCompany != null &&
        discount != null) {
      _navigateToPrintScreen(selectedDepartment, selectedCompany, discount);
    }
  }
}
