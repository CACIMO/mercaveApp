import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/api/woocommerce/coupon/wc_order.api.service.dart';
import 'package:mercave/app/core/services/api/woocommerce/product/wc_product.api.service.dart';
import 'package:mercave/app/core/services/api/woocommerce/utils/wc_utils.service.dart';
import 'package:mercave/app/core/services/app/cart.service.dart';
import 'package:mercave/app/core/services/app/coupon_service.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/shared/utils/date/date.service.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';

class OrderDetailController {
  Future validateCartProductsInStock({@required BuildContext context}) async {
    bool validProducts = true;
    String message = '';

    try {
      var cart = await CartService.getCart();
      List<String> cartProductsIds = [];

      /// ==============================================================
      /// Get the order products
      /// ==============================================================
      for (var i = 0; i < cart['products'].length; i++) {
        Map product = cart['products'][i];

        if (product['quantity'] > 0) {
          cartProductsIds.add(product['id'].toString());
        }
      }

      /// ==============================================================
      /// Get the general products
      /// ==============================================================
      List generalProducts = await WCProductAPIService().getProducts(
        productList: cartProductsIds,
      );

      /// ==============================================================
      /// Get the products not added
      /// ==============================================================
      List productsNotAdded = [];
      int listNumber = 1;
      for (var i = 0; i < generalProducts.length; i++) {
        for (var j = 0; j < cart['products'].length; j++) {
          if (cart['products'][j]['id'] == generalProducts[i]['id']) {
            Map productToAdd = WCUtils().formatProductToView(
              product: generalProducts[i],
            );

            int cartProductQuantity = cart['products'][j]['quantity'];
            int stockProductQuantity = productToAdd['stock_quantity'];

            if (!productToAdd['allow_add_to_cart'] ||
              stockProductQuantity < cartProductQuantity) {
              
              //Fix Product quantity in the Cart using stock quantity
              await CartService.updateProductQuantity(cart['products'][j],
                stockProductQuantity);

              productsNotAdded.add('${listNumber}. ${productToAdd['name']}\n'
                  '    (En carrito: $cartProductQuantity - '
                  'En existencia: $stockProductQuantity)');

              listNumber++;    
            }
          }
        }
      }

      /// ==================================================================
      /// There are products not added to the cart
      /// ==================================================================
      if (productsNotAdded.length > 0) {
        validProducts = false;
        message = 'Los siguientes artículos se encuentran agotados:\n\n' +
            productsNotAdded.join('\n');

        message += '\n\n Los artículos se han retirado de su carrito de '
          'compra, verifique y proceda a finalizar el pedido.';   
      }

      return Future.value({
        'validProducts': validProducts,
        'message': message,
      });
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<Map> validateCoupon({
    @required String couponCode,
    @required double cartTotal,
  }) async {
    String error;

    try {
      final userId = await AuthService.getUserIdLogged();
      final redeemableCoupon = await CouponService().requestCouponData(
        userId,
        couponCode,
      );
      final coupon = redeemableCoupon.toMap();
      error = getCouponError(couponData: coupon, cartTotal: cartTotal);

      if (error != null) {
        return Future.error(error);
      }

      return Future.value(coupon);
    } catch (e) {
      print(e);
      error = 'Error al validar el cupón. Inténtelo de nuevo más tarde.';
      return Future.error(error);
    }
  }

  String getCouponError({Map couponData, double cartTotal}) {
    String error;
    double minimumAmount = double.tryParse(couponData['minimum_amount']) ?? -1;
    double maximumAmount = double.tryParse(couponData['maximum_amount']) ?? -1;
    String dateExpires = couponData['date_expires'];

    int secondsToNow;
    if (dateExpires != null && dateExpires != '') {
      secondsToNow =
          DateService.getSecondsToNow(dateTime: DateTime.parse(dateExpires));
    }

    if (secondsToNow != null && secondsToNow <= 0) {
      error = 'El cupón ha expirado. Fecha de expiración: ' +
          DateTime.parse(dateExpires).toString().substring(0, 16);
    } else if (minimumAmount > 0 && cartTotal < minimumAmount) {
      error = 'Para aplicar el cupón '
              'el valor mínimo de la compra debe ser de ' +
          StringService.getPriceFormat(number: minimumAmount);
    } else if (maximumAmount > 0 && cartTotal > maximumAmount) {
      error = 'Para aplicar el cupón '
              'el valor máximo de la compra debe ser de ' +
          StringService.getPriceFormat(number: maximumAmount);
    }

    return error;
  }
}
