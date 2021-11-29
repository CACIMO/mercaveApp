import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/store/product_principal_slider/product_principal_slider.widget.ui.dart';

class ProductPrincipalSliderWidget extends StatelessWidget {
  final List<dynamic> products;
  final Function onProductTapped;

  ProductPrincipalSliderWidget({
    this.products,
    this.onProductTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ProductPrincipalSliderWidgetUI(
      context: context,
      products: products,
      onProductTapped: (product) {
        onProductTapped(product);
      },
    ).build();
  }
}
