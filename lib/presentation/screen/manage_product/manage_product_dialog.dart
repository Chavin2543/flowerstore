import 'package:flowerstore/data/datasource/category/model/request/add_category_request.dart';
import 'package:flowerstore/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/presentation/widget/dialog/add_product_dialog.dart';
import 'package:flowerstore/presentation/widget/dialog/input_dialog/core_one_input_dialog.dart';
import 'package:flowerstore/presentation/widget/dialog/input_dialog/core_three_input_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasource/category/model/request/patch_category_request.dart';
import '../../../data/datasource/product/model/add_product_request.dart';
import '../../../data/datasource/product/model/patch_product_request.dart';
import '../../../domain/entity/category.dart';
import '../../../domain/entity/product.dart';
import '../../../helper/customer_store.dart';
import '../../bloc/product/product_bloc.dart';
import '../loading_screen.dart';
import 'manage_product_screen.dart';

extension ManageProductScreenDialogs on ManageProductScreenState {
  void showProductEditDialog(Product product) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CoreThreeInputDialog(
          onSubmit: (response) {
            final customerId = CustomerStore.getCustomerId();
            if (customerId != null) {
              BlocProvider.of<ProductBloc>(context).add(
                PatchProductEvent(
                  request: PatchProductRequest(
                    name: response.input1,
                    unit: response.input2,
                    price: double.parse(response.input3),
                    id: product.id,
                    customerId: customerId,
                  ),
                ),
              );
            }
          },
          title: "แก้ไขสินค้า",
          input1Placeholder: "ชื่อ",
          prefillInput1: product.name,
          input2Placeholder: "หน่วย",
          prefillInput2: product.unit,
          input3Placeholder: "ราคา",
          prefillInput3: product.price.toString(),
          primaryButtonTitle: "ตกลง",
          secondaryButtonTitle: "ยกเลิก",
          autoFocusPosition: ThreeAutoFocusPosition.one,
        );
      },
    );
  }

  void showCategoryEditDialog(Category category) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CoreOneInputDialog(
          onSubmit: (response) {
            BlocProvider.of<CategoryBloc>(context).add(
              PatchCategoryEvent(
                PatchCategoryRequest(
                  name: response.input1,
                  categoryId: category.id,
                  customerId: category.customerId,
                ),
              ),
            );
          },
          title: "แก้ไขหมวดหมู่",
          input1Placeholder: "ชื่อหมวดหมู่",
          prefillInput1: category.name,
          primaryButtonTitle: "ตกลง",
          secondaryButtonTitle: "ยกเลิก",
          autoFocus: true,
        );
      },
    );
  }

  void showCategoryAddDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return CoreOneInputDialog(
          onSubmit: (response) {
            final customerId = CustomerStore.getCustomerId();
            if (customerId == null) {
              Navigator.pop(context);
              return;
            }
            BlocProvider.of<CategoryBloc>(context).add(
              AddCategoryEvent(
                AddCategoryRequest(
                  name: response.input1,
                  customerId: customerId,
                ),
              ),
            );
          },
          title: "เพิ่มหมวดหมู่",
          input1Placeholder: "ชื่อ",
          primaryButtonTitle: "ตกลง",
          secondaryButtonTitle: "ยกเลิก",
          autoFocus: true,
        );
      },
    );
  }

  void showProductAddDialog() {
    var categoryBlocState = BlocProvider.of<CategoryBloc>(context).state;
    if (categoryBlocState is CategoriesLoaded) {
      if (categoryBlocState.categories.isEmpty) {
        showCategoryAddDialog();
        return;
      }
    } else {
      return;
    }

    showDialog(
      context: context,
      builder: (dialogContext) {
        return MultiBlocProvider(
          providers: [
            BlocProvider.value(
              value: BlocProvider.of<CategoryBloc>(context),
            ),
            BlocProvider.value(
              value: BlocProvider.of<ProductBloc>(context),
            ),
          ],
          child: AddProductDialog(customer: widget.customer),
        );
      },
    );
  }

}
