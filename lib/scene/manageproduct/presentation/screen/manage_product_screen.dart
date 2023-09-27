import 'package:flowerstore/scene/createbill/data/model/add_category.dart';
import 'package:flowerstore/scene/createbill/data/model/add_product.dart';
import 'package:flowerstore/scene/createbill/data/model/category.dart';
import 'package:flowerstore/scene/createbill/data/model/patch_category.dart';
import 'package:flowerstore/scene/createbill/data/model/patch_product.dart';
import 'package:flowerstore/scene/createbill/data/model/product.dart';
import 'package:flowerstore/scene/createbill/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/scene/createbill/presentation/bloc/product/product_bloc.dart';
import 'package:flowerstore/scene/dashboard/data/model/customer.dart';
import 'package:flowerstore/scene/manageproduct/presentation/widget/manage_category_item.dart';
import 'package:flowerstore/scene/manageproduct/presentation/widget/manage_product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    BlocProvider.of<ProductBloc>(context).add(
      GetProductsEvent(
        DateTime.now(),
        widget.customer.id,
      ),
    );
    BlocProvider.of<CategoryBloc>(context).add(
      GetCategoriesEvent(
        DateTime.now(),
        widget.customer.id,
      ),
    );
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
                                    widget.customer.id,
                                  ),
                                );
                              },
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, position) {
                                return ManageCategoryItem(
                                  state.categories[position],
                                  () {},
                                  () {
                                    _showCategoryEditDialog(
                                        state.categories[position]);
                                  },
                                  (category) {
                                    setState(() {
                                      if (selectedCategory == category.id) {
                                        selectedCategory = null;

                                        BlocProvider.of<ProductBloc>(context).add(
                                          GetProductsEvent(
                                            DateTime.now(),
                                            widget.customer.id,
                                          ),
                                        );
                                      } else {
                                        selectedCategory = category.id;

                                        BlocProvider.of<ProductBloc>(context).add(
                                          QueryProductByCategoryEvent(
                                            category.id,
                                            widget.customer.id,
                                          ),
                                        );
                                      }
                                    });
                                  },
                                  selectedCategory == state.categories[position].id,
                                );
                              },
                              itemCount: state.categories.length,
                            ),
                          ],
                        );
                      } else {
                        return Container();
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
                                      .add(QueryProductByTextEvent(
                                    text,
                                    widget.customer.id,
                                    categoryId: selectedCategory,
                                  ));
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
                        return Container();
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
                BlocProvider.of<CategoryBloc>(context).add(
                  PatchCategoryEvent(
                    PatchCategory(
                      name: name,
                    ),
                  ),
                );
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
                BlocProvider.of<ProductBloc>(context)
                    .add(PatchProductEvent(PatchProduct(
                  name: name,
                  unit: unit,
                  price: price,
                  id: product.id,
                )));
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
                BlocProvider.of<ProductBloc>(context).add(
                  PostProductEvent(
                    AddProduct(
                      name: name,
                      price: price,
                      unit: unit,
                      customerId: widget.customer.id,
                    ),
                  ),
                );
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
                BlocProvider.of<CategoryBloc>(context).add(
                  PostCategoryEvent(
                    AddCategory(
                      name: name,
                    ),
                  ),
                );
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
