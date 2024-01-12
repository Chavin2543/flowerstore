import 'package:flowerstore/presentation/screen/loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flowerstore/data/datasource/product/model/get_product_request.dart';
import 'package:flowerstore/presentation/bloc/category/category_bloc.dart';
import 'package:flowerstore/presentation/bloc/product/product_bloc.dart';

import '../../../domain/entity/product.dart';
import '../item/product_item.dart';

class PrefillItemSection extends StatefulWidget {
  final Function(Product) onTap;
  final int customerId;

  const PrefillItemSection({
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
            _buildCategorySection(context, constraints),
            _buildProductSection(context, constraints),
          ],
        );
      },
    );
  }

  Widget _buildCategorySection(
      BuildContext context, BoxConstraints constraints) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        border: Border.all(color: Colors.black),
      ),
      height: MediaQuery.of(context).size.height * 0.405,
      width: constraints.maxWidth / 2,
      child: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoriesLoaded) {
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: _buildCategorySearchField(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: SingleChildScrollView(
                    child: _buildCategoryList(state),
                  ),
                ),
              ],
            );
          } else {
            return const LoadingScreen();
          }
        },
      ),
    );
  }

  Widget _buildProductSection(
      BuildContext context, BoxConstraints constraints) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        border: Border.all(color: Colors.black),
      ),
      height: MediaQuery.of(context).size.height * 0.405,
      width: constraints.maxWidth / 2,
      child: BlocBuilder<ProductBloc, ProductState>(
        builder: (context, state) {
          if (state is ProductsLoaded) {
            return Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.05,
                  child: _buildProductSearchField(),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.35,
                  child: SingleChildScrollView(
                    child: _buildProductList(state),
                  ),
                ),
              ],
            );
          } else {
            return const LoadingScreen();
          }
        },
      ),
    );
  }

  Widget _buildCategorySearchField() {
    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: "ค้นหาหมวดหมู่",
          hintStyle: Theme.of(context).textTheme.bodyLarge),
      controller: _categorySearchController,
      onChanged: (text) {
        BlocProvider.of<CategoryBloc>(context).add(QueryCategoryEvent(text));
      },
    );
  }

  Widget _buildProductSearchField() {
    return TextField(
      decoration: InputDecoration(
          prefixIcon: const Icon(Icons.search),
          hintText: "ค้นหาสินค้า",
          hintStyle: Theme.of(context).textTheme.bodyLarge),
      controller: _productSearchController,
      onChanged: (text) {
        BlocProvider.of<ProductBloc>(context).add(
          QueryProductByTextEvent(text, categoryId: selectedCategory),
        );
      },
    );
  }

  Widget _buildCategoryList(CategoriesLoaded state) {
    return ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, position) {
        return ProductItem(
          name: state.categories[position].name,
          onTap: () => _handleCategoryTap(context, state, position),
          isSelected: selectedCategory == state.categories[position].id,
        );
      },
      itemCount: state.categories.length,
    );
  }

  Widget _buildProductList(ProductsLoaded state) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, position) {
        return ProductItem(
          name: state.products[position].name,
          price: state.products[position].price,
          unit: state.products[position].unit,
          onTap: () => _handleProductTap(state.products[position]),
          isSelected: false,
        );
      },
      itemCount: state.products.length,
    );
  }

  void _handleCategoryTap(
      BuildContext context, CategoriesLoaded state, int position) {
    _categorySearchController.clear();
    _productSearchController.clear();

    setState(() {
      if (selectedCategory == state.categories[position].id) {
        selectedCategory = null;
        BlocProvider.of<ProductBloc>(context)
            .add(GetProductEvent(request: GetProductRequest()));
      } else {
        selectedCategory = state.categories[position].id;
        BlocProvider.of<ProductBloc>(context).add(
          QueryProductByCategoryEvent(state.categories[position].id),
        );
      }
    });
  }

  void _handleProductTap(Product product) {
    _categorySearchController.clear();
    _productSearchController.clear();
    widget.onTap(product);
  }
}
