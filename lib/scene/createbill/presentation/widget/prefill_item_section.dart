import 'package:flowerstore/scene/createbill/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/scene/createbill/presentation/bloc/product/product_bloc.dart';
import 'package:flowerstore/scene/createbill/presentation/widget/product_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/model/product.dart';

class PrefillItemSection extends StatefulWidget {
  final ValueChanged<Product> onTap;
  final int customerId;

  PrefillItemSection({
    Key? key,
    required this.onTap,
    required this.customerId,
  }) : super(key: key);

  @override
  State<PrefillItemSection> createState() => _PrefillItemSectionState();
}

class _PrefillItemSectionState extends State<PrefillItemSection> {
  final _productSearchController = TextEditingController();
  final _categorySearchController = TextEditingController();

  int? selectedCategory;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          children: [
            Container(
              decoration:
                  BoxDecoration(color: Theme.of(context).colorScheme.primary),
              height: MediaQuery.of(context).size.height * 0.4,
              width: constraints.maxWidth / 2,
              child: BlocBuilder<CategoryBloc, CategoryState>(
                builder: (context, state) {
                  if (state is CategoriesLoaded) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: "ค้นหาหมวดหมู่",
                                hintStyle:
                                    Theme.of(context).textTheme.displayLarge),
                            onChanged: (text) {
                              BlocProvider.of<CategoryBloc>(context)
                                  .add(QueryCategoryEvent(
                                text,
                                widget.customerId,
                              ));
                            },
                            controller: _productSearchController,
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, position) {
                              return ProductItem(
                                name: state.categories[position].name,
                                onTap: () {
                                  _categorySearchController.text = "";
                                  _productSearchController.text = "";

                                  setState(() {
                                    if (selectedCategory ==
                                        state.categories[position].id) {
                                      selectedCategory = null;

                                      BlocProvider.of<ProductBloc>(context).add(
                                        GetProductsEvent(
                                          DateTime.now(),
                                          widget.customerId,
                                        ),
                                      );
                                    } else {
                                      selectedCategory =
                                          state.categories[position].id;
                                      BlocProvider.of<ProductBloc>(context).add(
                                        QueryProductByCategoryEvent(
                                          state.categories[position].id,
                                          widget.customerId,
                                        ),
                                      );
                                    }
                                  });
                                },
                                isSelected: selectedCategory ==
                                    state.categories[position].id,
                              );
                            },
                            itemCount: state.categories.length,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
              ),
              height: MediaQuery.of(context).size.height * 0.4,
              width: constraints.maxWidth / 2,
              child: BlocBuilder<ProductBloc, ProductState>(
                builder: (context, state) {
                  if (state is ProductsLoaded) {
                    return SingleChildScrollView(
                      physics: AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          TextField(
                            decoration: InputDecoration(
                                prefixIcon: const Icon(Icons.search),
                                hintText: "ค้นหาสินค้า",
                                hintStyle:
                                    Theme.of(context).textTheme.displayLarge),
                            controller: _categorySearchController,
                            onChanged: (text) {
                              BlocProvider.of<ProductBloc>(context).add(
                                QueryProductByTextEvent(text, widget.customerId,
                                    categoryId: selectedCategory),
                              );
                            },
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            itemBuilder: (context, position) {
                              return ProductItem(
                                name: state.products[position].name,
                                price: state.products[position].price,
                                unit: state.products[position].unit,
                                onTap: () {
                                  _categorySearchController.text = "";
                                  _productSearchController.text = "";

                                  widget.onTap(state.products[position]);
                                },
                                isSelected: false,
                              );
                            },
                            itemCount: state.products.length,
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.3,
                          )
                        ],
                      ),
                    );
                  } else {
                    return Container();
                  }
                },
              ),
            )
          ],
        );
      },
    );
  }
}
