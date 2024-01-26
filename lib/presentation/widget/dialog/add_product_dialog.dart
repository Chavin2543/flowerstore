import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/datasource/product/model/add_product_request.dart';
import '../../../domain/entity/category.dart';
import '../../../domain/entity/customer.dart';
import '../../bloc/category/category_bloc.dart';
import '../../bloc/product/product_bloc.dart';
import '../../screen/loading_screen.dart';

class AddProductDialog extends StatefulWidget {
  final Customer customer;

  const AddProductDialog({Key? key, required this.customer}) : super(key: key);

  @override
  AddProductDialogState createState() => AddProductDialogState();
}

class AddProductDialogState extends State<AddProductDialog> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController unitController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  int? selectedCategory;

  @override
  void initState() {
    super.initState();
  }

  void _submitForm() {
    if (formKey.currentState!.validate()) {
      String name = nameController.text;
      String unit = unitController.text;
      double price = double.parse(priceController.text);
      addProduct(
        name: name,
        unit: unit,
        price: price,
      );
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("เพิ่มสินค้า"),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "ชื่อสินค้า",
                  ),
                  onSubmitted: (_) => _submitForm(),
                  autofocus: true),
              TextField(
                controller: unitController,
                decoration: const InputDecoration(
                  labelText: "หน่วย",
                ),
                onSubmitted: (_) => _submitForm(),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: "ราคา",
                ),
                onSubmitted: (_) => _submitForm(),
              ),
              BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoriesLoaded) {
                    selectedCategory ??= state.categories.first.id;
                    return DropdownButtonFormField<String>(
                      value: selectedCategory.toString(),
                      decoration:
                          const InputDecoration(hintText: "เลือกหมวดหมู่"),
                      onChanged: (value) {
                        setState(() {
                          print(value);
                          if (value != null) {
                            int? selectedValue = int.parse(value);
                            selectedCategory = selectedValue;
                          }
                        });
                      },
                      items: state.categories
                          .map(
                            (Category category) {
                              return DropdownMenuItem<String>(
                                value: category.id.toString(),
                                child: Text(category.name),
                              );
                            },
                          )
                          .toList()
                          .cast<DropdownMenuItem<String>>(),
                    );
                  } else {
                    return const LoadingScreen();
                  }
                },
                bloc: BlocProvider.of<CategoryBloc>(context),
              )
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitForm,
          child: Text(
            "ตกลง",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "ยกเลิก",
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }

  void addProduct({
    required String name,
    required String unit,
    required double price,
  }) {
    if (selectedCategory != null) {
      BlocProvider.of<ProductBloc>(context).add(
        AddProductEvent(
          request: AddProductRequest(
            name: name,
            price: price,
            unit: unit,
            categoryId: selectedCategory,
            customerId: widget.customer.id,
          ),
        ),
      );
    }
  }
}
