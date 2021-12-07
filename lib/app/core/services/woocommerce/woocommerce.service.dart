import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:mercave/app/core/config.service.dart';
import 'package:mercave/app/core/services/app/cart.service.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/core/services/http/http.service.dart';
import 'package:mercave/app/core/services/session/session.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/cart_product/cart_product.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';
import 'package:woocommerce_api/woocommerce_api.dart';

class WooCommerceService {
  WooCommerceAPI _wcAPI;
  String ownWooCommerceKeys;

  WooCommerceService() {
    this._wcAPI = WooCommerceAPI(
      url: ConfigService.WC_ENDPOINT,
      consumerKey: ConfigService.WC_CONSUMER_KEY,
      consumerSecret: ConfigService.WC_CONSUMER_SECRET,
    );

    this.ownWooCommerceKeys = "consumer_key=${ConfigService.WC_CONSUMER_KEY}" +
        "&consumer_secret=${ConfigService.WC_CONSUMER_SECRET}";
  }

  Future<dynamic> getInStockQueryParam() async {
    dynamic configApp = await SessionService.getItem(key: 'app_config');
    configApp = json.decode(configApp);

    return Future.value(
        configApp['show_soldout_products'] == 1 ? '' : '&in_stock=true');
  }

  /// ==========================================================================
  /// Product Functions
  /// ==========================================================================
  Future<dynamic> getRecommendedProducts({
    int categoryId,
    int offset = 0,
  }) async {
    String endpoint;
    List<dynamic> recommendedProducts = [];
    List<dynamic> products = [];
    String inStockParam = await getInStockQueryParam();

    try {
      if (ConfigService.USE_OWN_WOOCOMMERCE_API) {
        endpoint = "${ConfigService.WC_OWN_ENDPOINT}wc_products.php" +
            '?featured=true&orderby=title&offset=$offset&order=asc$inStockParam' +
            '&$ownWooCommerceKeys';

        if (categoryId != null) {
          endpoint += '&category=' + categoryId.toString();
        }
        products = await HttpService.get(url: endpoint);
      } else {
        endpoint = "products";
        if (categoryId != null) {
          endpoint += '?category=' +
              categoryId.toString() +
              '&featured=true&orderby=title&offset=$offset&order=asc$inStockParam';
        } else {
          endpoint +=
              '?featured=true&orderby=title&offset=$offset&order=asc$inStockParam';
        }

        products = await this._wcAPI.getAsync(endpoint);
      }

      List<dynamic> cart =
          await CartProductDBService.getAllCartProducts(cartId: 1);

      recommendedProducts = products.map((product) {
        return formatProductToView(product, cart);
      }).toList();

      return Future.value(recommendedProducts);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getProductsOnOffers({int offset = 0}) async {
    List<dynamic> recommendedProducts = [];
    String inStockParam = await getInStockQueryParam();
    String endpoint;
    List<dynamic> products;

    try {
      if (ConfigService.USE_OWN_WOOCOMMERCE_API) {
        endpoint = "${ConfigService.WC_OWN_ENDPOINT}wc_products.php" +
            '?orderby=title&order=asc&offset=$offset&on_sale=true$inStockParam' +
            '&$ownWooCommerceKeys';
        products = await HttpService.get(url: endpoint);
      } else {
        endpoint =
            "products?orderby=title&order=asc&offset=$offset&on_sale=true$inStockParam";
        products = await this._wcAPI.getAsync(endpoint);
      }

      List<dynamic> cart =
          await CartProductDBService.getAllCartProducts(cartId: 1);

      recommendedProducts = products.map((product) {
        return formatProductToView(product, cart);
      }).toList();

      return Future.value(recommendedProducts);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getProductsBySearch({String textToSearch}) async {
    List<dynamic> productsFound = [];
    String inStockParam = await getInStockQueryParam();
    String endpoint;
    List<dynamic> products;

    try {
      if (ConfigService.USE_OWN_WOOCOMMERCE_API) {
        endpoint = "${ConfigService.WC_OWN_ENDPOINT}wc_products.php" +
            '?search=$textToSearch&orderby=title&order=asc$inStockParam' +
            '&$ownWooCommerceKeys';
        products = await HttpService.get(url: endpoint);
      } else {
        endpoint =
            "products?search=$textToSearch&orderby=title&order=asc$inStockParam";
        products = await this._wcAPI.getAsync(endpoint);
      }

      List<dynamic> cart =
          await CartProductDBService.getAllCartProducts(cartId: 1);

      productsFound = products.map((product) {
        return formatProductToView(product, cart);
      }).toList();

      return Future.value(productsFound);
    } catch (e) {
      return Future.error(e);
    }
  }

  Future<dynamic> getProductsByCategory({
    int categoryId,
    int offset = 0,
  }) async {
    List<dynamic> categoryProducts = [];
    String inStockParam = await getInStockQueryParam();
    String endpoint;
    List<dynamic> products;

    try {
      if (ConfigService.USE_OWN_WOOCOMMERCE_API) {
        endpoint = "${ConfigService.WC_OWN_ENDPOINT}wc_products.php" +
            '?category=$categoryId&offset=$offset&orderby=title&order=asc$inStockParam' +
            '&$ownWooCommerceKeys';
        products = await HttpService.get(url: endpoint);
      } else {
        endpoint =
            "products?category=$categoryId&offset=$offset&orderby=title&order=asc$inStockParam";
        products = await this._wcAPI.getAsync(endpoint);
      }

      List<dynamic> cart =
          await CartProductDBService.getAllCartProducts(cartId: 1);

      categoryProducts = products.map((product) {
        return formatProductToView(product, cart);
      }).toList();

      return Future.value(categoryProducts);
    } catch (e) {
      return Future.error(e);
    }
  }

  /// ==========================================================================
  /// Category Functions
  /// ==========================================================================
  Future<dynamic> getCategories() async {
    List<dynamic> categories = [];

    try {
      String endpoint;
      List<dynamic> wcCategories;

      if (ConfigService.USE_OWN_WOOCOMMERCE_API) {
        endpoint = "${ConfigService.WC_OWN_ENDPOINT}wc_categories.php" +
            '?$ownWooCommerceKeys';
        wcCategories = await HttpService.get(url: endpoint);
      } else {
        endpoint = "products/categories?per_page=100";
        wcCategories = await this._wcAPI.getAsync(endpoint);
      }

      categories = wcCategories
          .map((category) => formatCategoryToView(category))
          .toList();
      categories = wcCategories.where((i) => i['count'] > 0).toList();

      return Future.value(categories);
    } catch (e) {
      return Future.error(e);
    }
  }

  /// ==========================================================================
  /// This function allows to:
  ///
  /// 1. Set a null value if there is no valid value for product prices.
  /// 2. Transform the product description to be handle for the UI.
  /// 3. Calculate the product amount saved.
  /// 4. Calculate the product regular price amount.
  /// ==========================================================================
  Map formatProductToView(Map product, List cart) {
    product['name'] = StringService.capitalize(product['name']);
    product['price'] = double.tryParse(product['price'].toString());
    product['regular_price'] =
        double.tryParse(product['regular_price'].toString());

    product['unit_measure'] = '1 Kg';
    product['amount_saved'] = null;
    product['discount'] = null;

    product['quantity'] = 0;
    for (int i = 0; i < cart.length; i++) {
      if (cart[i].productId == product['id']) {
        product['quantity'] = cart[i].quantity;
      }
    }

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
    } catch (e) {
      print('error');
      print(e);
    }

    product['hide_actions'] = false;
    product['show_quantity_in_price'] = false;

    return product;
  }

  /// ==========================================================================
  /// This function allow to:
  ///
  /// 1. Set a category default image if there is none.
  /// ==========================================================================
  Map formatCategoryToView(Map category) {
    if (category['image'] != null && category['image']['src'] != null) {
      category['principal_image'] = category['image']['src'];
    } else {
      category['principal_image'] =
          'https://www.mercave.com.co/wp-content/uploads/2019/12/Moda-1.jpg';
    }

    return category;
  }

  /// ==========================================================================
  /// Place an order to wcoCommerce
  /// ==========================================================================
  Future saveOrder({Map couponData, double couponDiscountTotal}) async {
    var cart = await CartService.getCart();
    var orderCreatedInfo;

    List orderProducts = [];

    /// ==============================================================
    /// Get user data
    /// ==============================================================
    int userId = await AuthService.getUserIdLogged();
    Map userData = await UserDBService.getUserById(id: userId);
    String address = userData['type_of_road'] +
        ' ' +
        userData['plate_part_1'] +
        ' # ' +
        userData['plate_part_2'] +
        ' - ' +
        userData['plate_part_3'] +
        ', Barrio ' +
        userData['neighborhood'];

    /// ==============================================================
    /// Get delivery info
    /// ==============================================================
    var deliveryDateSelected = await SessionService.getItem(
      key: 'deliveryDateSelected',
    );

    /// ==============================================================
    /// Get the order notes
    /// ==============================================================
    var orderNotes = await SessionService.getItem(
      key: 'orderNotes',
    );

    var deliveryToHourSelected = await SessionService.getItem(
      key: 'deliveryToHourSelected',
    );

    var deliveryFromHourSelected = await SessionService.getItem(
      key: 'deliveryFromHourSelected',
    );

    /// ==============================================================
    /// Set coupon info
    /// ==============================================================
    String discountType = '';
    double discountQuantity = 0;

    List couponLines = [];
    if (couponData != null) {
      discountType = couponData['discount_type'];
      discountQuantity = double.tryParse(couponData['amount']);

      couponLines.add(
        {
          'code': couponData['code'],
          "discount": couponDiscountTotal.toString(),
        },
      );
    }

    /// ==============================================================
    /// Get the order products
    /// ==============================================================
    int cartProductItems = 0;
    for (var i = 0; i < cart['products'].length; i++) {
      Map product = cart['products'][i];
      cartProductItems += product['quantity'];
    }

    for (var i = 0; i < cart['products'].length; i++) {
      Map product = cart['products'][i];
      double itemPrice = product['price'];
      double itemCouponDiscount = 0;

      double subtotalItemQuantityPrice = product['price'] * product['quantity'];
      double totalItemQuantityPrice = product['price'] * product['quantity'];

      if (discountType == 'percent') {
        itemCouponDiscount = itemPrice * discountQuantity / 100;
        totalItemQuantityPrice =
            (itemPrice - itemCouponDiscount) * product['quantity'];
      } else if (discountType == 'fixed_cart') {
        itemCouponDiscount = discountQuantity / cartProductItems;
        totalItemQuantityPrice = itemPrice * product['quantity'] -
            itemCouponDiscount * product['quantity'];
      }

      if (product['quantity'] > 0) {
        orderProducts.add(
          {
            'product_id': product['id'],
            'quantity': product['quantity'],
            'subtotal': subtotalItemQuantityPrice.toString(),
            'total': totalItemQuantityPrice.toString(),
          },
        );
      }
    }

    /// ==============================================================
    /// Set the data to be sent to create the order
    /// ==============================================================
    String paymentMethod = '';
    String paymentMethodTitle = '';
    String orderStatus = '';
    String toPayWithText = await SessionService.getItem(key: 'toPayWithCash');
    String customerNote = '';

    if (userData['payment_method'] == 'dataphone') {
      paymentMethod = 'alg_custom_gateway_1';
      paymentMethodTitle = 'Pago a contra entrega con datáfono';
      orderStatus = 'on-hold';
    } else if (userData['payment_method'] == 'cash') {
      paymentMethod = 'cod';
      paymentMethodTitle = 'Pago a contra entrega con efectivo';
      orderStatus = 'on-hold';
      customerNote = 'A pagar con \$ $toPayWithText. ';
    } else if (userData['payment_method'] == 'online') {
      paymentMethod = 'epayco';
      paymentMethodTitle = 'Tu Compra - En Línea';
      orderStatus = 'pending';
    }

    if (orderNotes != null) {
      customerNote += orderNotes;
    }

    Map orderData = {
      'customer_id': userData['id'],
      'customer_note': customerNote,
      "payment_method": paymentMethod,
      "payment_method_title": paymentMethodTitle,
      "set_paid": false,
      "status": orderStatus,
      "billing": {
        "first_name": userData['first_name'],
        "last_name": userData['last_name'],
        "company": "",
        "address_1": address,
        "address_2": userData['address_info'],
        "city": "Cali",
        "state": "Valle del Cauca",
        "postcode": "7600",
        "country": "CO",
        "email": userData['email'],
        "phone": userData['phone'] ?? ''
      },
      "shipping": {
        "first_name": userData['first_name'],
        "last_name": userData['last_name'],
        "company": "",
        "address_1": address,
        "address_2": userData['address_info'],
        "city": "Cali",
        "state": "Valle del Cauca",
        "postcode": "7600",
        "country": "CO",
        "email": userData['email'],
        "phone": userData['phone'] ?? ''
      },
      "coupon_lines": couponLines,
      "meta_data": [
        {
          "key": "_billing_identificacion",
          "value": userData['billing_identification_number'],
        },
        {
          "key": "is_vat_exempt",
          "value": "no",
        },
        {
          "key": "_delivery_date",
          "value": deliveryDateSelected,
        },
        {
          "key": "_delivery_time_frame",
          "value": {
            "time_from": deliveryFromHourSelected,
            "time_to": deliveryToHourSelected,
          }
        },
        {
          "key": "_shipping_date",
          "value": deliveryDateSelected,
        },
        {
          "key": "billing_identificacion",
          "value": userData['billing_identification_number'],
        },
        {
          "key": "is_vat_exempt",
          "value": "no",
        }
      ],
      'line_items': orderProducts,
    };

    /// ==============================================================
    /// Create the order
    /// ==============================================================
    try {
      var response = await _wcAPI.postAsync(
        'orders',
        orderData,
      );

      if (response['data'] != null && response['data']['status'] != 200) {
        return Future.error(
          PlatformException(
            code: '-1',
            message: response['message'],
          ),
        );
      }

      return Future.value(response);
    } catch (e) {
      Future.error(PlatformException(
        code: '-1',
        message: e.toString(),
      ));
    }

    return Future.value(orderCreatedInfo);
  }

  /// ==========================================================================
  /// Place an order note to a specific order to wcoCommerce
  /// ==========================================================================
  Future saveOrderNote({
    @required int orderId,
    @required String orderNote,
  }) async {
    try {
      var response = await _wcAPI.postAsync(
        'orders/$orderId/notes',
        {'note': orderNote},
      );

      if (response['data'] != null && response['data']['status'] != 200) {
        return Future.error(
          PlatformException(
            code: '-1',
            message: response['message'],
          ),
        );
      }

      return Future.value(response);
    } catch (e) {
      Future.error(PlatformException(
        code: '-1',
        message: e.toString(),
      ));
    }

    return Future.value(true);
  }
}
