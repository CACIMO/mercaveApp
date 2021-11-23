import 'dart:convert';

import 'package:mercave/app/core/services/sqlite/tables/cart_product/cart_product.model.dart';
import 'package:mercave/app/core/services/sqlite/tables/cart_product/cart_product.service.dart';
import 'package:mercave/app/core/services/woocommerce/woocommerce.service.dart';
import 'package:mercave/app/shared/utils/list/list.service.dart';

class CartService {
  static Future getCart() async {
    double cartTotal = 0;
    double cartAmountSaved = 0;
    List cartProducts = [];

    try {
      List products = await CartProductDBService.getAllCartProducts(cartId: 1);
      List<dynamic> cart =
          await CartProductDBService.getAllCartProducts(cartId: 1);

      cartProducts = products.map((product) {
        var dataProduct = jsonDecode(product.data);
        dataProduct =
            WooCommerceService().formatProductToView(dataProduct, cart);

        cartTotal += product.quantity * product.price;
        if (dataProduct['amount_saved'] != null) {
          cartAmountSaved += product.quantity * dataProduct['amount_saved'];
        }
        dataProduct['quantity'] = product.quantity;

        return dataProduct;
      }).toList();
    } catch (e) {
      return Future.error(e);
    }

    ListService.orderByAttribute(cartProducts);

    return Future.value({
      'cart_total': cartTotal,
      'amount_saved': cartAmountSaved,
      'products': cartProducts
    });
  }

  static Future updateProductQuantity(Map product, quantity) async {
    int productId = product['id'];

    CartProduct cartProduct = new CartProduct(
      productId: productId,
      cartId: 1,
      quantity: quantity,
      price: product['price'],
      data: jsonEncode(product),
    );

    try {
      await CartProductDBService.createOrUpdateCartProduct(cartProduct);
    } catch (e) {
      return Future.error(e);
    }
    return Future.value(true);
  }
}
