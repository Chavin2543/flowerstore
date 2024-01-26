import 'package:flowerstore/data/datasource/category/model/request/delete_category_request.dart';
import 'package:flowerstore/data/datasource/category/model/request/get_category_request.dart';
import 'package:flowerstore/data/datasource/category/model/request/patch_category_request.dart';
import 'package:flowerstore/data/datasource/product/model/delete_product_request.dart';
import 'package:flowerstore/data/datasource/product/model/get_product_request.dart';
import 'package:flowerstore/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/presentation/bloc/product/product_bloc.dart';
import 'package:flowerstore/presentation/screen/loading_screen.dart';
import 'package:flowerstore/presentation/screen/manage_product/manage_product_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entity/category.dart';
import '../../../domain/entity/customer.dart';
import '../../widget/item/manage_category_item.dart';
import '../../widget/item/manage_product_item.dart';

class ManageProductScreen extends StatefulWidget {
  const ManageProductScreen(this.customer, {Key? key}) : super(key: key);

  final Customer customer;

  @override
  State<ManageProductScreen> createState() => ManageProductScreenState();
}

class ManageProductScreenState extends State<ManageProductScreen> {
  final formKey = GlobalKey<FormState>();
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
          title: Text("กำหนดราคาสำหรับโรงแรม",
              style: Theme.of(context).textTheme.bodyLarge),
          actions: [
            TextButton(
                onPressed: () {
                  showProductAddDialog();
                },
                child: Text(
                  "เพิ่มสินค้า",
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
            TextButton(
                onPressed: () {
                  showCategoryAddDialog();
                },
                child: Text(
                  "เพิ่มหมวดหมู่",
                  style: Theme.of(context).textTheme.bodyLarge,
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
                            SizedBox(
                              height: proxy.maxHeight * 0.05,
                              child: TextField(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: "ค้นหาหมวดหมู่",
                                  hintStyle:
                                  Theme.of(context).textTheme.bodyLarge,
                                ),
                                controller: _categorySearchController,
                                onChanged: (text) {
                                  BlocProvider.of<CategoryBloc>(context).add(
                                    QueryCategoryEvent(
                                      text,
                                    ),
                                  );
                                },
                              ),
                            ),
                            SizedBox(
                              height: proxy.maxHeight * 0.95,
                              child: ListView.builder(
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
                                      showCategoryEditDialog(
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
                              height: proxy.maxHeight * 0.05,
                              color: Theme.of(context).colorScheme.surface,
                              child: TextField(
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.search),
                                  hintText: "ค้นหาสินค้า",
                                  hintStyle:
                                      Theme.of(context).textTheme.bodyLarge,
                                ),
                                controller: _productSearchController,
                                onChanged: (text) {
                                  BlocProvider.of<ProductBloc>(context)
                                      .add(QueryProductByTextEvent(text));
                                },
                              ),
                            ),
                            SizedBox(
                              height: proxy.maxHeight * 0.95,
                              child: ListView.builder(
                                shrinkWrap: true,
                                itemBuilder: (context, position) {
                                  return ManageProductItem(
                                    state.products[position],
                                        () {
                                      final product = state.products[position];
                                      BlocProvider.of<ProductBloc>(context).add(
                                        DeleteProductEvent(
                                          request: DeleteProductRequest(
                                              id: product.id,
                                              customerId: product.customerId),
                                        ),
                                      );
                                    },
                                        () {
                                      showProductEditDialog(
                                          state.products[position]);
                                    },
                                  );
                                },
                                itemCount: state.products.length,
                              ),
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
}
