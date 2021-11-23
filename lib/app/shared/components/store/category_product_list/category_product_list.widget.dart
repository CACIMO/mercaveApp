import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/store/category_product_list/category_product_list.widget.ui.dart';

class CategoryProductListWidget extends StatelessWidget {
  final List<dynamic> products;
  final Map category;
  final Function onProductDecreased;
  final Function onProductIncreased;
  final ScrollController scrollController;
  final bool loadingMoreProducts;
  final Function onProductTapped;
  final bool fullHeight;

  CategoryProductListWidget({
    @required this.category,
    @required this.products,
    @required this.onProductDecreased,
    @required this.onProductIncreased,
    @required this.scrollController,
    @required this.loadingMoreProducts,
    @required this.onProductTapped,
    @required this.fullHeight,
  });

  @override
  Widget build(BuildContext context) {
    return CategoryProductListWidgetUI(
      context: context,
      category: category,
      products: products,
      onProductDecreased: onProductDecreased,
      onProductIncreased: onProductIncreased,
      scrollController: scrollController,
      loadingMoreProducts: loadingMoreProducts,
      onProductTapped: onProductTapped,
      fullHeight: fullHeight,
    ).build();
  }
}
