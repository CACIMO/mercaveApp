import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/app/cart.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/pages/store/product/product_detail/product_detail.page.ui.dart';
import 'package:mercave/app/pages/store/product/product_zoom/product_zoom.page.dart';

class ProductDetailPage extends StatefulWidget {
  final dynamic productParam;

  ProductDetailPage({this.productParam});

  @override
  _ProductDetailPageState createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  bool loading = false;
  bool error = false;
  Map currentProduct;

  @override
  void initState() {
    super.initState();
    load();
  }

  load() {
    setState(() {
      currentProduct = widget.productParam;
    });
  }

  @override
  build(BuildContext context) {
    return ProductDetailPageUI(
      context: context,
      productParam: widget.productParam,
      currentProduct: currentProduct,
      loading: loading,
      error: error,
      onError: load,
      onProductDecreased: (product) {
        int newProductQuantity = product['quantity'] - 1;

        CartService.updateProductQuantity(
          product,
          newProductQuantity,
        ).then((response) {
          setState(() {
            product['quantity'] = newProductQuantity;
          });
        });
      },
      onProductIncreased: (product) {
        bool inStock = product['in_stock'];
        int stockQuantity = product['stock_quantity'];

        if (inStock && product['quantity'] + 1 <= stockQuantity) {
          int newProductQuantity = product['quantity'] + 1;

          CartService.updateProductQuantity(
            product,
            newProductQuantity,
          ).then((response) {
            setState(() {
              product['quantity'] = newProductQuantity;
            });
          });
        } else {
          AlertService.showErrorAlert(
            context: context,
            title: 'Stock',
            description:
                'Solo existe $stockQuantity existencia(s) del producto ' +
                    product['name'],
          );
        }
      },
      onProductTapped: (product) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductZoomPage(productParam: product),
          ),
        );
      },
    ).build();
  }
}
