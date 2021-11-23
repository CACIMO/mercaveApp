import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/store/product_image_slider/product_image_slider.widget.ui.dart';

class ProductImageSliderWidget extends StatelessWidget {
  final List<dynamic> products;
  final Function onProductTapped;

  ProductImageSliderWidget({
    this.products,
    this.onProductTapped,
  });

  @override
  Widget build(BuildContext context) {
    return ProductImageSliderWidgetUI(
      context: context,
      products: products,
      onProductTapped: (product) {
        onProductTapped(product);
      },
    ).build();
  }
}
