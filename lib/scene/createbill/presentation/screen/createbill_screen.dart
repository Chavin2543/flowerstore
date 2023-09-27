import 'package:flowerstore/scene/createbill/presentation/bloc/category/entity/bill_item_model.dart';
import 'package:flowerstore/scene/createbill/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/scene/createbill/presentation/bloc/product/product_bloc.dart';
import 'package:flowerstore/scene/createbill/presentation/widget/bill_summary.dart';
import 'package:flowerstore/scene/createbill/presentation/widget/createbill_item.dart';
import 'package:flowerstore/scene/createbill/presentation/widget/custom_product_dialog.dart';
import 'package:flowerstore/scene/createbill/presentation/widget/prefill_item_section.dart';
import 'package:flowerstore/scene/dashboard/data/model/customer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/product.dart';

class CreateBillScreen extends StatefulWidget {
  const CreateBillScreen(this.customer, {Key? key}) : super(key: key);

  final Customer customer;

  @override
  State<CreateBillScreen> createState() => _CreateBillScreenState();
}

class _CreateBillScreenState extends State<CreateBillScreen> {
  List<BillItemModel> currentBillItems = [];

  @override
  void initState() {

    print(widget.customer.id);

    BlocProvider.of<CategoryBloc>(context).add(GetCategoriesEvent(
      DateTime.now(),
      widget.customer.id,
    ));
    BlocProvider.of<ProductBloc>(context).add(GetProductsEvent(
      DateTime.now(),
      widget.customer.id,
    ));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "สร้างบิล",
          style: Theme.of(context).textTheme.displayLarge,
        ),
        actions: [
          IconButton(
            onPressed: () {
              BlocProvider.of<ProductBloc>(context)
                  .add(GetProductsEvent(DateTime.now(), widget.customer.id));
              BlocProvider.of<CategoryBloc>(context).add(GetCategoriesEvent(
                DateTime.now(),
                widget.customer.id,
              ));
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            PrefillItemSection(
              onTap: (product) {
                openCustomProductDialog(product, context);
              },
              customerId: widget.customer.id,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: ReorderableListView(
                onReorder: _onReorder,
                children: currentBillItems.map((item) {
                  return CreateBillItem(
                    key: Key(item.product.id.toString()),
                    product: item.product,
                    quantity: item.quantity,
                    onDelete: () {
                      deleteBillByProduct(item);
                    },
                    onDecrease: () {
                      deductBillByProduct(item, null);
                    },
                    onIncrease: () {
                      addBillByProduct(item, null);
                    },
                  );
                }).toList(),
              ),
            ),
            BillSummary(
              total: currentBillItems.total,
              onContinue: () {},
            )
          ],
        ),
      ),
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final BillItemModel item = currentBillItems.removeAt(oldIndex);
      currentBillItems.insert(newIndex, item);
    });
  }

  Widget _buildListItem(BuildContext context, BillItemModel item) {
    return ListTile(
      key: Key(item.product.id.toString()),
      title: Text(item.product.name),
      // other widgets and properties
    );
  }

  void addBillByProduct(BillItemModel targetProduct, int? quantity) {
    setState(() {
      currentBillItems = currentBillItems.map((billItem) {
        if (billItem.product.id == targetProduct.product.id) {
          if (quantity != null) {
            if (targetProduct.quantity == 0) {
              return BillItemModel(
                product: billItem.product,
                quantity: quantity,
              );
            } else {
              return BillItemModel(
                product: billItem.product,
                quantity: billItem.quantity + targetProduct.quantity,
              );
            }
          } else {
            return BillItemModel(
              product: billItem.product,
              quantity: billItem.quantity + 1,
            );
          }
        } else {
          return billItem;
        }
      }).toList();
    });
  }

  void deductBillByProduct(BillItemModel targetProduct, int? quantity) {
    if (currentBillItems
                .firstWhere((billItem) =>
                    billItem.product.id == targetProduct.product.id)
                .quantity +
            1 ==
        0) {
      deleteBillByProduct(targetProduct);
      return;
    }

    setState(() {
      currentBillItems = currentBillItems.map((billItem) {
        if (billItem.product.id == targetProduct.product.id) {
          if (quantity != null) {
            return BillItemModel(
              product: billItem.product,
              quantity: billItem.quantity - targetProduct.quantity,
            );
          } else {
            return BillItemModel(
              product: billItem.product,
              quantity: billItem.quantity - 1,
            );
          }
        } else {
          return billItem;
        }
      }).toList();
    });
  }

  void deleteBillByProduct(BillItemModel targetProduct) {
    setState(() {
      currentBillItems.removeWhere(
        (billItem) => billItem.product.id == targetProduct.product.id,
      );
    });
  }

  void openCustomProductDialog(Product product, BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return CustomProductDialog(
          product: product,
          onSubmit: (billItem) {
            if (currentBillItems.indexWhere(
                    (element) => element.product.id == product.id) ==
                -1) {
              setState(() {
                currentBillItems.add(billItem);
              });
            } else {
              addBillByProduct(billItem, billItem.quantity);
            }
          },
        );
      },
    );
  }
}
