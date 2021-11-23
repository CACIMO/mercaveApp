import 'package:flutter/cupertino.dart';
import 'package:mercave/app/shared/components/store/cart_product_list/cart_product_list.widget.ui.dart';

class CartProductListWidget extends StatelessWidget {
  final List<dynamic> products;
  final Function onProductDecreased;
  final Function onProductIncreased;
  final Function onProductTapped;

  CartProductListWidget({
    @required this.products,
    @required this.onProductDecreased,
    @required this.onProductIncreased,
    @required this.onProductTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CartProductListWidgetUI(
      context: context,
      products: products,
      onProductDecreased: onProductDecreased,
      onProductIncreased: onProductIncreased,
      onProductTapped: onProductTapped,
    ).build();
  }
}
