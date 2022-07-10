import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mercave/app/core/config.service.dart';
import 'package:mercave/app/core/services/app/cart.service.dart';
import 'package:mercave/app/core/services/app/config.api.service.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/core/services/session/session.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/core/services/utils/version_checker/version_checker.service.dart';
import 'package:mercave/app/core/services/woocommerce/woocommerce.service.dart';
import 'package:mercave/app/pages/account/_home/home.page.dart';
import 'package:mercave/app/pages/account/address/address.page.dart';
import 'package:mercave/app/pages/account/user_menu/user_menu.page.dart';
import 'package:mercave/app/pages/store/_home/home.page.ui.dart';
import 'package:mercave/app/pages/store/cart/cart_detail/cart_detail.page.dart';
import 'package:mercave/app/pages/store/category/category_detail/category_detail.page.dart';
import 'package:mercave/app/pages/store/product/product_detail/product_detail.page.dart';
import 'package:mercave/app/pages/store/product/search_product/search_product.page.dart';
import 'package:mercave/app/shared/components/buttons/round_button/round_button.widget.dart';
import 'package:mercave/app/ui/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool loading = false;
  bool error = false;

  List<dynamic> recommendedProducts = [];
  List<dynamic> productsOnOffered = [];
  List<dynamic> categories = [];

  Map versionData;
  Map userData;
  String avatar;
  bool userIsLogged = false;
  int cartProductsQty = 0;

  bool loginPageDisplayed = false;

  @override
  initState() {
    super.initState();
    isLoginPageDisplayed();
    loadData();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
    // else{ // DESARROLLO
    //   print('SetState no se puede ejecutar !!!');
    // }
  }

  // Retrieve value from localStorage in SQLite and set it in local variable loginPageDisplayed
  isLoginPageDisplayed() async {
    await SessionService.getItem(key: 'loginPageDisplayed').then((value) async {
      if (value != null) {
        loginPageDisplayed = value == 'true' ? true : false;
      }
    });
  }

  loadData() async {
    setState(() {
      error = false;
      loading = true;
    });

    try {
      Map config = await ConfigAPIService.getConfig();
      await SessionService.setItem(
        key: 'app_config',
        value: json.encode(config),
      );

      print('Config $config');

      versionData = await VersionCheckerService.versionCheck(
        configAppVersion: config['current_app_version'],
      );

      categories = await WooCommerceService().getCategories();
      recommendedProducts = await WooCommerceService().getRecommendedProducts();
      productsOnOffered = await WooCommerceService().getProductsOnOffers();

      _getUserData();
      _getCart();

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = true;
        error = true;
      });
    }

    await SessionService.removeItem(key: 'reloadHomePage');
  }

  void _getUserData() async {
    int userIdLogged = await AuthService.getUserIdLogged();

    userData = null;
    avatar = null;
    userIsLogged = false;

    if (userIdLogged != null) {
      userData = await UserDBService.getUserById(id: userIdLogged);
    }

    if (userIdLogged > 0) {
      setState(() {
        userIsLogged = true;
      });
    }

    // if (userData != null) {
    //   setState(() {
    //     if (userIdLogged > 0) userIsLogged = true;
    //     avatar = userData['avatar'];
    //   });
    // } else {
    //   setState(() {
    //     userIsLogged = false;
    //     avatar = null;
    //   });
    // }

    //If User is not Logged In and hasn't been redirected to Login page
    //then redirect them to Login page
    if (!userIsLogged && !loginPageDisplayed) {
      SessionService.setItem(key: 'loginPageDisplayed', value: 'true');
      setState(() {
        loginPageDisplayed = true;
      });
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomeLoginPage(),
        ),
      );
    }
  }

  void _getCart() {
    CartService.getCart().then((cart) {
      cartProductsQty = 0;

      for (int i = 0; i < cart['products'].length; i++) {
        cartProductsQty += cart['products'][i]['quantity'];
      }

      setState(() {});
    }).catchError((error) {});
  }

  void refreshProducts() async {
    String reloadAllInfo = await SessionService.getItem(
      key: 'reloadHomePage',
    );

    if (reloadAllInfo != null) {
      loadData();
      return;
    }

    CartService.getCart().then((cart) {
      cartProductsQty = 0;

      for (int i = 0; i < cart['products'].length; i++) {
        cartProductsQty += cart['products'][i]['quantity'];
      }

      for (int i = 0; i < recommendedProducts.length; i++) {
        recommendedProducts[i]['quantity'] = 0;
      }

      for (int i = 0; i < productsOnOffered.length; i++) {
        productsOnOffered[i]['quantity'] = 0;
      }

      for (int i = 0; i < cart['products'].length; i++) {
        for (int j = 0; j < recommendedProducts.length; j++) {
          if (recommendedProducts[j]['id'] == cart['products'][i]['id']) {
            recommendedProducts[j]['quantity'] =
                cart['products'][i]['quantity'];
          }
        }

        for (int j = 0; j < productsOnOffered.length; j++) {
          if (productsOnOffered[j]['id'] == cart['products'][i]['id']) {
            productsOnOffered[j]['quantity'] = cart['products'][i]['quantity'];
          }
        }
      }

      setState(() {});
    }).catchError((error) {});
  }

  @override
  Widget build(BuildContext context) {
    if (versionData != null && versionData['update_version']) {
      return _getNoEqualVersionWidget();
    } else {
      print('Versiones $versionData');
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primaryColor: kCustomSecondaryColor),
        home: HomePageUI(
          context: context,
          recommendedProducts:
              recommendedProducts.length != 0 ? recommendedProducts : [],
          productsOnOffered:
              productsOnOffered.length != 0 ? productsOnOffered : [],
          categories: categories ?? [],
          userData: userData,
          userIsLogged: userIsLogged,
          cartProductsQty: cartProductsQty,
          loading: loading,
          error: error,
          onError: loadData,
          onProductTapped: (product) async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailPage(productParam: product),
              ),
            );

            _getUserData();
            refreshProducts();
          },
          onCategoryTapped: (category) async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CategoryDetailPage(categoryParam: category),
              ),
            );

            _getUserData();
            refreshProducts();
          },
          onHeaderTitleTapped: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddressPage(),
              ),
            );

            _getUserData();
            refreshProducts();
          },
          onSearchIconTapped: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SearchProductPage(),
              ),
            );

            _getUserData();
            refreshProducts();
          },
          onUserIconTapped: () async {
            int userIdLogged = await AuthService.getUserIdLogged();

            if (userIdLogged == 0) {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeLoginPage(),
                ),
              );
            } else {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserMenuPage(),
                ),
              );
            }

            _getUserData();
            refreshProducts();
          },
          onCartIconTapped: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => CartDetailPage(),
              ),
            );

            _getUserData();
            refreshProducts();
          },
        ).build(),
      );
    }
  }

  Widget _getNoEqualVersionWidget() {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomSecondaryColor),
      home: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset(
                    'assets/icons/logo_mercave_gris.png',
                    width: MediaQuery.of(context).size.width * 90 / 100,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 5.0,
                    bottom: 40.0,
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'MercaVé está mejor que nunca',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: kCustomBlackColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Text(
                          'La última versión de tu app es más rápida y segura. Actualizala para seguir '
                          'usando MercaVé. \n\n V.${versionData['current_version']} a V.${versionData['new_version']}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16.0,
                            color: kCustomGrayTextColor,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ButtonTheme(
                          height: 50.0,
                          minWidth:
                              MediaQuery.of(context).size.width * 60 / 100,
                          child: RoundButtonWidget(
                            text: 'Actualizar',
                            onPressed: () async {
                              String storeUrl = Platform.isIOS
                                  ? ConfigService.APP_STORE_URL
                                  : ConfigService.PLAY_STORE_URL;

                              if (await canLaunch(storeUrl)) {
                                await launch(storeUrl, forceSafariVC: false);
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
