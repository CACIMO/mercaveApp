import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/api/woocommerce/order/wc_order.api.service.dart';
import 'package:mercave/app/core/services/api/woocommerce/product/wc_product.api.service.dart';
import 'package:mercave/app/core/services/api/woocommerce/utils/wc_utils.service.dart';
import 'package:mercave/app/core/services/app/cart.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/cart_product/cart_product.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/core/services/utils/loader/loader.service.dart';
import 'package:mercave/app/pages/store/cart/cart_detail/cart_detail.page.dart';

class OrderDetailController {
  Future getOrderInfo({@required int orderId}) async {
    Map order;

    List orderProducts;
    List generalProducts;

    try {
      /// ======================================================================
      /// Get the wooCommerce order
      /// ======================================================================
      order = await WCOrderAPIService().getOrderById(
        orderId: orderId,
      );

      /// ======================================================================
      /// Get all the info related to each product in the order
      /// ======================================================================
      orderProducts = order['line_items'];

      List<String> productList = [];
      for (var i = 0; i < orderProducts.length; i++) {
        productList.add(orderProducts[i]['product_id'].toString());
      }

      generalProducts = await WCProductAPIService().getProducts(
        productList: productList,
      );

      /// ======================================================================
      /// Get the products order view info
      /// ======================================================================
      generalProducts = WCUtils().formatOrderProductToView(
        products: generalProducts,
        orderProducts: orderProducts,
      );
    } catch (e) {
      return Future.error(e);
    }

    return Future.value({
      'order': order,
      'products': generalProducts,
    });
  }

  void createCartBasedOnOrder({
    @required BuildContext context,
    @required int orderId,
  }) async {
    AlertService.showConfirmAlert(
      context: context,
      title: 'Crear Canasta',
      description: 'En realidad desea crear una canasta con los productos '
          'del pedido No. $orderId ? \n\n'
          'NOTA: Esta acción eliminará cualquier producto '
          'agregado actualmente a la canasta.',
      onTapOk: () async {
        LoaderService.showLoader(
          context: context,
          text: 'Creando carrito...',
        );

        try {
          /// ==================================================================
          /// Get the wooCommerce order
          /// ==================================================================
          Map order = await WCOrderAPIService().getOrderById(
            orderId: orderId,
          );

          /// ==================================================================
          /// Get all the info related to each product in the order
          /// ==================================================================
          List orderProducts = order['line_items'];
          List<String> productList = [];

          for (var i = 0; i < orderProducts.length; i++) {
            productList.add(orderProducts[i]['product_id'].toString());
          }

          List generalProducts = await WCProductAPIService().getProducts(
            productList: productList,
          );

          /// ==================================================================
          /// Set the product quantity to the order product quantity
          /// ==================================================================
          await CartProductDBService.deleteCartProducts(cartId: 1);

          List productsNotAdded = [];

          for (var i = 0; i < generalProducts.length; i++) {
            for (var j = 0; j < orderProducts.length; j++) {
              if (orderProducts[j]['product_id'] == generalProducts[i]['id']) {
                Map productToAdd = WCUtils().formatProductToView(
                  product: generalProducts[i],
                );

                int quantityToAdd = orderProducts[j]['quantity'];
                int stockProductQuantity = productToAdd['stock_quantity'];

                if (productToAdd['allow_add_to_cart'] &&
                    stockProductQuantity >= quantityToAdd) {
                  await CartService.updateProductQuantity(
                    productToAdd,
                    quantityToAdd,
                  );
                } else {
                  productsNotAdded.add('* ' + productToAdd['name']);
                }
              }
            }
          }

          /// ==================================================================
          /// There are no available order products to add in the cart
          /// ==================================================================
          LoaderService.dismissLoader(context: context);

          if (productsNotAdded.length == generalProducts.length) {
            AlertService.showErrorAlert(
                context: context,
                title: 'Error',
                description:
                    'Ninguno de los productos se encuentra disponible. '
                    'Intente de crear el carrito de nuevo más tarde.');
            return;
          }

          /// ==================================================================
          /// There are products not added to the cart
          /// ==================================================================
          if (productsNotAdded.length > 0) {
            AlertService.showDynamicErrorAlert(
              context: context,
              title: Text(
                'Productos No Agregados',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
              description: Text(
                'Los siguientes productos no pudieron ser '
                        'agregados al carrito debido a que no se encuentran '
                        'disponibles. \n\n' +
                    productsNotAdded.join('\n'),
                style: TextStyle(
                  fontSize: 10.0,
                ),
              ),
            );
          }

          /// ==================================================================
          /// Redirect to the cart page
          /// ==================================================================
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CartDetailPage(),
            ),
          );
        } catch (e) {
          LoaderService.dismissLoader(context: context);

          AlertService.showErrorAlert(
            context: context,
            title: 'Error',
            description: e.message,
          );
        }
      },
      onTapCancel: () {},
    );
  }
}
