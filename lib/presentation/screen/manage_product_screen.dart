import 'package:flowerstore/data/datasource/category/model/request/add_category_request.dart';
import 'package:flowerstore/data/datasource/category/model/request/delete_category_request.dart';
import 'package:flowerstore/data/datasource/category/model/request/get_category_request.dart';
import 'package:flowerstore/data/datasource/category/model/request/patch_category_request.dart';
import 'package:flowerstore/data/datasource/product/model/get_product_request.dart';
import 'package:flowerstore/helper/customer_store.dart';
import 'package:flowerstore/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/presentation/bloc/product/product_bloc.dart';
import 'package:flowerstore/presentation/screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/datasource/product/model/add_product_request.dart';
import '../../data/datasource/product/model/patch_product_request.dart';
import '../../domain/entity/category.dart';
import '../../domain/entity/customer.dart';
import '../../domain/entity/product.dart';
import '../widget/item/manage_category_item.dart';
import '../widget/item/manage_product_item.dart';

class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen(this.customer, {Key? key}) : super(key: key);

  final Customer customer;

  @override
  State<ManageProductScreen> createState() => _ManageProductScreenState();
}

class _ManageProductScreenState extends State<ManageProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _categorySearchController = TextEditingController();
  final _productSearchController = TextEditingController();
  int? selectedCategory;

  @override
  void initState() {
    BlocProvider.of<ProductBloc>(context)
        .add(GetProductEvent(request: GetProductRequest()));
    BlocProvider.of<CategoryBloc>(context)
        .add(GetCategoriesEvent(request: const GetCategoryRequest()));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("กำหนดราคาสำหรับโรงแรม"),
          actions: [
            TextButton(
                onPressed: () {
                  _showProductAddDialog();
                },
                child: Text(
                  "เพิ่มสินค้า",
                  style: Theme.of(context).textTheme.displayLarge,
                )),
            TextButton(
                onPressed: () {
                  _showCategoryAddDialog();
                },
                child: Text(
                  "เพิ่มหมวดหมู่",
                  style: Theme.of(context).textTheme.displayLarge,
                )),
          ],
        ),
        body: LayoutBuilder(
          builder: (context, proxy) {
            return Row(
              children: [
                SizedBox(
                  width: proxy.maxWidth * 0.3,
                  child: BlocBuilder<CategoryBloc, CategoryState>(
                    builder: (context, state) {
                      if (state is CategoriesLoaded) {
                        return Column(
                          children: [
                            TextField(
                              decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: "ค้นหาหมวดหมู่",
                                  hintStyle:
                                      Theme.of(context).textTheme.displayLarge),
                              controller: _categorySearchController,
                              onChanged: (text) {
                                BlocProvider.of<CategoryBloc>(context).add(
                                  QueryCategoryEvent(
                                    text,
                                  ),
                                );
                              },
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, position) {
                                return ManageCategoryItem(
                                  state.categories[position],
                                  () {
                                    final category = state.categories[position];
                                    BlocProvider.of<CategoryBloc>(context).add(
                                      DeleteCategoryEvent(
                                        DeleteCategoryRequest(
                                            categoryId: category.id),
                                      ),
                                    );
                                  },
                                  () {
                                    _showCategoryEditDialog(
                                        state.categories[position]);
                                  },
                                  (Category category) {
                                    setState(() {
                                      if (selectedCategory == category.id) {
                                        selectedCategory = null;
                                        BlocProvider.of<ProductBloc>(context)
                                            .add(GetProductEvent(
                                                request: GetProductRequest()));
                                        BlocProvider.of<CategoryBloc>(context)
                                            .add(GetCategoriesEvent(
                                                request:
                                                    const GetCategoryRequest()));
                                      } else {
                                        selectedCategory = category.id;

                                        BlocProvider.of<ProductBloc>(context)
                                            .add(
                                          QueryProductByCategoryEvent(
                                            category.id,
                                          ),
                                        );
                                      }
                                    });
                                  },
                                  selectedCategory ==
                                      state.categories[position].id,
                                );
                              },
                              itemCount: state.categories.length,
                            ),
                          ],
                        );
                      } else {
                        return const LoadingScreen();
                      }
                    },
                  ),
                ),
                Container(
                  color: Colors.grey,
                  width: proxy.maxWidth * 0.7,
                  child: BlocBuilder<ProductBloc, ProductState>(
                    builder: (context, state) {
                      if (state is ProductsLoaded) {
                        return Column(
                          children: [
                            Container(
                              color: Theme.of(context).colorScheme.surface,
                              child: TextField(
                                decoration: InputDecoration(
                                    prefixIcon: const Icon(Icons.search),
                                    hintText: "ค้นหาสินค้า",
                                    hintStyle: Theme.of(context)
                                        .textTheme
                                        .displayLarge),
                                controller: _productSearchController,
                                onChanged: (text) {
                                  BlocProvider.of<ProductBloc>(context)
                                      .add(QueryProductByTextEvent(text));
                                },
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, position) {
                                return ManageProductItem(
                                  state.products[position],
                                  () {
                                    _showProductEditDialog(
                                        state.products[position]);
                                  },
                                  () {
                                    _showProductEditDialog(
                                        state.products[position]);
                                  },
                                );
                              },
                              itemCount: state.products.length,
                            ),
                          ],
                        );
                      } else {
                        return const LoadingScreen();
                      }
                    },
                  ),
                ),
              ],
            );
          },
        ));
  }

  void _showCategoryEditDialog(Category category) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        String name = category.name;

        return AlertDialog(
          title: const Text('แก้ไขหมวดหมู่'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: category.name,
                  onChanged: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่ข้อมูล';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('บันทึก'),
              onPressed: () {
                BlocProvider.of<CategoryBloc>(context)
                    .add(PatchCategoryEvent(PatchCategoryRequest(
                  name: name,
                  categoryId: category.id,
                  customerId: category.customerId,
                )));
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showProductEditDialog(Product product) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        String name = product.name;
        String unit = product.unit;
        double price = product.price;

        return AlertDialog(
          title: const Text('แก้ไขสินค้า'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  initialValue: product.name,
                  onChanged: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่ข้อมูล';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: product.unit,
                  onChanged: (value) {
                    unit = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่ข้อมูล';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  initialValue: product.price.toString(),
                  onChanged: (value) {
                    price = double.tryParse(value) ?? product.price;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่ข่อมูล';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('บันทึก'),
              onPressed: () {
                final customerId = CustomerStore.getCustomerId();

                if (customerId != null) {
                  BlocProvider.of<ProductBloc>(context).add(
                    PatchProductEvent(
                      request: PatchProductRequest(
                        name: name,
                        unit: unit,
                        price: price,
                        id: product.id,
                        customerId: customerId,
                      ),
                    ),
                  );
                }

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showProductAddDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        String name = "";
        String unit = "";
        double price = 0.0;
        int? selectedCategory = null; // Initialize the selected category

        return AlertDialog(
          title: const Text('เพิ่มสินค้า'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(hintText: "ชื่อสินค้า"),
                  onChanged: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่ข้อมูล';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "หน่วย"),
                  onChanged: (value) {
                    unit = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่ข้อมูล';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: const InputDecoration(hintText: "ราคา"),
                  onChanged: (value) {
                    price = double.tryParse(value) ?? 0.00;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่ข่อมูล';
                    }
                    return null;
                  },
                ),
                BlocBuilder<CategoryBloc, CategoryState>(
                  builder: (context, state) {
                    if (state is CategoriesLoaded) {
                      selectedCategory = state.categories.first.id;
                      return DropdownButtonFormField<String>(
                        value: selectedCategory.toString(),
                        decoration:
                            const InputDecoration(hintText: "เลือกหมวดหมู่"),
                        // Customize the hintText
                        onChanged: (value) {
                          setState(() {
                            if (value != null) {
                              int? selectedValue = int.parse(value);
                              if (selectedValue != null) {
                                selectedCategory = selectedValue;
                              }
                            }
                          });
                        },
                        items: state.categories.map((Category category) {
                          return DropdownMenuItem<String>(
                            value: category.id.toString(),
                            child: Text(category.name),
                          );
                        }).toList(),
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
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('บันทึก'),
              onPressed: () {
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
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void _showCategoryAddDialog() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        String name = "";

        return AlertDialog(
          title: const Text('เพิ่มหมวดหมู่'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  decoration: const InputDecoration(hintText: "ชื่อหมวดหมู่"),
                  onChanged: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'กรุณาใส่ข้อมูล';
                    }
                    return null;
                  },
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('ยกเลิก'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('บันทึก'),
              onPressed: () {
                final customerId = CustomerStore.getCustomerId();

                if (customerId != null) {
                  BlocProvider.of<CategoryBloc>(context).add(
                    AddCategoryEvent(
                        AddCategoryRequest(name: name, customerId: customerId)),
                  );
                }

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
