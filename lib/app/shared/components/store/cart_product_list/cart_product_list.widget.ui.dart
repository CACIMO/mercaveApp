import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/store/product_list_item/product_list_item.widget.dart';

class CartProductListWidgetUI {
  final BuildContext context;
  final List<dynamic> products;
  final Function onProductDecreased;
  final Function onProductIncreased;
  final Function onProductTapped;

  CartProductListWidgetUI({
    @required this.context,
    @required this.products,
    @required this.onProductDecreased,
    @required this.onProductIncreased,
    @required this.onProductTapped,
  });

  Widget build() {
    return Column(
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height - 195.0,
          child: _getProductCategoryListWidget(),
        ),
      ],
    );
  }

  Widget _getProductCategoryListWidget() {
    return ListView.builder(
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ProductListItemWidget(
            product: products[index],
            onProductDecreased: onProductDecreased,
            onProductIncreased: onProductIncreased,
            onProductTapped: onProductTapped);
      },
    );
  }
}
