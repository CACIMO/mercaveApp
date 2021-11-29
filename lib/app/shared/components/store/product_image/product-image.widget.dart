import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/store/product_image/product_image.widget.ui.dart';

class ProductImageWidget extends StatelessWidget {
  final Map product;
  final Function onProductTapped;
  final double imageHeight;

  ProductImageWidget({
    this.product,
    this.onProductTapped,
    this.imageHeight,
  });

  @override
  Widget build(BuildContext context) {
    return ProductImageWidgetUI(
      context: context,
      product: product,
      onProductTapped: (product) {
        onProductTapped(product);
      },
      imageHeight: imageHeight,
    ).build();
  }
}
