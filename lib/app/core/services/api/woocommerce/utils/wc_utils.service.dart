import 'package:flutter/foundation.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';

class WCUtils {
  List formatOrderProductToView({
    @required List products,
    @required orderProducts,
  }) {
    for (var i = 0; i < products.length; i++) {
      products[i] = formatProductToView(product: products[i]);

      for (var j = 0; j < orderProducts.length; j++) {
        if (orderProducts[j]['product_id'] == products[i]['id']) {
          products[i]['quantity'] = orderProducts[j]['quantity'];

          products[i]['total'] =
              double.tryParse(orderProducts[j]['total'].toString());
          products[i]['price'] =
              double.tryParse(orderProducts[j]['price'].toString());
          products[i]['regular_price'] = null;
          products[i]['amount_saved'] = null;
          products[i]['discount'] = null;

          products[i]['allow_add_to_cart'] = false;
          products[i]['hide_actions'] = true;
          products[i]['show_quantity_in_price'] = true;
        }
      }
    }

    return products;
  }

  Map formatProductToView({@required Map product}) {
    product['name'] = StringService.capitalize(product['name']);
    product['price'] = double.tryParse(product['price'].toString());
    product['regular_price'] =
        double.tryParse(product['regular_price'].toString());

    product['unit_measure'] = '1 Kg';
    product['amount_saved'] = null;
    product['discount'] = null;

    product['quantity'] = 0;

    product['principal_image'] = product['images'][0]['src'];
    product['description'] =
        StringService.removeAllHtmlTags(product['description']) != ''
            ? StringService.removeAllHtmlTags(product['description'])
            : kCustomNoProductDescriptionText;

    product['short_description'] =
        StringService.removeAllHtmlTags(product['short_description']) != ''
            ? StringService.removeAllHtmlTags(product['short_description'])
            : '';

    if (product['regular_price'] != product['price'] &&
        product['regular_price'] != null &&
        product['price'] != null) {
      product['amount_saved'] = product['regular_price'] - product['price'];
      product['discount'] =
          100 - product['price'] * 100 / product['regular_price'];
    } else {
      product['regular_price'] = null;
    }

    try {
      product['allow_add_to_cart'] = product['price'] != null &&
              product['in_stock'] &&
              product['stock_quantity'] > 0
          ? true
          : false;
    } catch (e) {}

    product['hide_actions'] = false;
    product['show_quantity_in_price'] = false;

    return product;
  }
}
