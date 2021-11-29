import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/store/product_list_item/product_list_item.widget.ui.dart';

class ProductListItemWidget extends StatelessWidget {
  final Map product;
  final Function onProductDecreased;
  final Function onProductIncreased;
  final Function onProductTapped;

  ProductListItemWidget({
    @required this.product,
    @required this.onProductDecreased,
    @required this.onProductIncreased,
    @required this.onProductTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ProductListItemWidgetUI(
            context: context,
            product: product,
            onProductDecreased: onProductDecreased,
            onProductIncreased: onProductIncreased,
            onProductTapped: onProductTapped)
        .build();
  }
}
