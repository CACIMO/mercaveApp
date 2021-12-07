import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mercave/app/ui/constants.dart';

class ProductImageWidgetUI {
  final BuildContext context;
  final Map product;
  final Function onProductTapped;
  final double imageHeight;

  ProductImageWidgetUI({
    @required this.context,
    @required this.product,
    @required this.onProductTapped,
    this.imageHeight,
  });

  Widget build() {
    return GestureDetector(
      onTap: () {
        onProductTapped(product);
      },
      child: Stack(
        children: <Widget>[
          _getProductImageWidget(),
          _getProductDiscountWidget(),
        ],
      ),
    );
  }

  Widget _getProductImageWidget() {
    double imageHeightLocal = imageHeight ?? 150;
    
    return CachedNetworkImage(
      height: imageHeightLocal,
      imageUrl: product['principal_image'],
      placeholder: (context, url) => Image.asset(
        kCustomPlaceholderImage,
        height: imageHeightLocal,
      ),
      errorWidget: (context, url, error) => Icon(Icons.error),
    );
  }

  Widget _getProductDiscountWidget() {
    bool visible = product['discount'] != null;

    return Visibility(
      visible: visible,
      child: Positioned(
        top: -20.0,
        right: -5.0,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 10.0),
          child: Container(
            width: 55.0,
            height: 55.0,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(kCustomDiscountImage),
                fit: BoxFit.cover,
              ),
            ),
            child: _getProductDiscountTextWidget(),
          ),
        ),
      ),
    );
  }

  Widget _getProductDiscountTextWidget() {
    String discount = product['discount'] != null
        ? product['discount'].toStringAsFixed(0) + ' %'
        : '';

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          discount,
          style: TextStyle(
            color: kCustomPrimaryColor,
            fontSize: 16.0,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
