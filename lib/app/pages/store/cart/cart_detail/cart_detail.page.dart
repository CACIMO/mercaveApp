import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/app/cart.service.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/pages/account/address/address.page.dart';
import 'package:mercave/app/pages/store/cart/cart_detail/cart_detail.page.ui.dart';

class CartDetailPage extends StatefulWidget {
  @override
  _CartDetailPageState createState() => _CartDetailPageState();
}

class _CartDetailPageState extends State<CartDetailPage> {
  List<dynamic> products = [];
  double total = 0.0;
  double saved = 0.0;
  bool loading = true;
  bool error = false;

  Map userData;
  String avatar;
  bool userIsLogged = false;

  @override
  void initState() {
    super.initState();
    load();
    _getUserData();
  }

  load({bool showLoadings = true}) {
    if (!showLoadings) {
      setState(() {
        loading = true;
        error = false;
      });
    }

    CartService.getCart().then((cart) {
      products = cart['products'];
      total = cart['cart_total'];
      saved = cart['amount_saved'];

      if (showLoadings) {
        loading = false;
      }
      setState(() {});
    }).catchError((error) {
      setState(() {
        loading = false;
        error = true;
      });
    });
  }

  void _getUserData() async {
    int userIdLogged = await AuthService.getUserIdLogged();

    userData = null;
    avatar = null;
    userIsLogged = false;

    if (userIdLogged != null) {
      userData = await UserDBService.getUserById(id: userIdLogged);
    }

    if (userData != null) {
      setState(() {
        if (userIdLogged > 0) userIsLogged = true;
        avatar = userData['avatar'];
      });
    } else {
      setState(() {
        userIsLogged = false;
        avatar = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CartDetailPageUI(
        context: context,
        products: products,
        userData: userData,
        userIsLogged: userIsLogged,
        total: total,
        saved: saved,
        loading: loading,
        error: error,
        onError: load(),
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
        onAddressHeaderTapped: () async {
          await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddressPage(),
              ));

          _getUserData();
        }).build();
  }
}
