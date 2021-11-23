import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/sqlite/tables/cart_product/cart_product.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/pages/store/cart/order_detail/order_detail_stepper.dart';
import 'package:mercave/app/pages/store/product/product_detail/product_detail.page.dart';
import 'package:mercave/app/pages/store/product/search_product/search_product.page.dart';
import 'package:mercave/app/shared/components/buttons/chip_button/chip_button.widget.dart';
import 'package:mercave/app/shared/components/buttons/round_button/round_button.widget.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/shared/components/store/cart_product_list/cart_product_list.widget.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';

class CartDetailPageUI {
  final BuildContext context;
  List<dynamic> products = [];
  final double total;
  final double saved;
  final bool loading;
  final bool error;
  final Function onError;
  final Function onProductDecreased;
  final Function onProductIncreased;
  final Function onAddressHeaderTapped;
  final Map userData;
  final bool userIsLogged;

  CartDetailPageUI({
    @required this.context,
    @required this.products,
    @required this.total,
    @required this.saved,
    @required this.loading,
    @required this.error,
    @required this.onError,
    @required this.onProductDecreased,
    @required this.onProductIncreased,
    @required this.onAddressHeaderTapped,
    @required this.userData,
    @required this.userIsLogged,
  });

  Widget build() {
    Widget homeWidget;

    if (loading || error) {
      return PageLoaderWidget(
        error: loading,
        onError: onError,
      );
    }

    if (products.length > 0) {
      homeWidget = _getCartProductListWidget();
    } else {
      homeWidget = _getEmptyCartWidget();
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomSecondaryColor),
      home: homeWidget,
    );
  }

  Widget _getCartProductListWidget() {
    String address = '- # -';

    if (userData != null) {
      if (userData['type_of_road'] != null) {
        address = userData['type_of_road'] +
            ' ' +
            userData['plate_part_1'] +
            ' # ' +
            userData['plate_part_2'] +
            ' -' +
            userData['plate_part_3'];
      }
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () => Navigator.pop(context, false),
                    child: Image.asset(
                      'assets/icons/back_arrow.png',
                      width: 25.0,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 10.0),
              Expanded(
                flex: 8,
                child: GestureDetector(
                  onTap: () {
                    onAddressHeaderTapped();
                  },
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Carrito',
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: <Widget>[
                          Text(
                            address,
                            style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 10.0),
              Visibility(
                visible: products.length > 0,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () {
                        AlertService.showConfirmAlert(
                            context: context,
                            title: 'Limpiar carrito?',
                            description: 'En realidad desea quitar todos '
                                'los productos agregados al carrito?',
                            onTapOk: () async {
                              await CartProductDBService.deleteCartProducts(
                                  cartId: 1);
                            });
                      },
                      child: Icon(Icons.remove_shopping_cart),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: Stack(
          children: [
            new Container(
              height: 140.0,
              color: kCustomGrayColor,
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'Total:',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: kCustomBlackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              StringService.getPriceFormat(number: total),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: kCustomBlackColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              'Estás ahorrando:',
                              style: TextStyle(
                                fontSize: 18.0,
                                color: kCustomPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16.0,
                            ),
                            child: Text(
                              StringService.getPriceFormat(number: saved),
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontSize: 18.0,
                                color: kCustomPrimaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ButtonTheme(
                        height: 50.0,
                        minWidth: MediaQuery.of(context).size.width,
                        child: RoundButtonWidget(
                          textColor: kCustomWhiteColor,
                          text: 'Siguiente',
                          onPressed: () async {
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrderDetailStepper(context: context,),
                                //builder: (context) => CartOrderDetailPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              CartProductListWidget(
                products: products,
                onProductDecreased: onProductDecreased,
                onProductIncreased: onProductIncreased,
                onProductTapped: (product) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProductDetailPage(productParam: product),
                    ),
                  );
                },
              ),
            ],
          ),
        ));
  }

  Widget _getEmptyCartWidget() {
    return Scaffold(
      backgroundColor: kCustomGrayColor,
      appBar: AppBar(
        title: Text(''),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () => Navigator.pop(context, false),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
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
                    'El carrito de compras está vacío',
                    style: TextStyle(
                      fontSize: 18.0,
                      color: kCustomBlackColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Agrega tu primer producto y disfruta del supermercado del ahorro',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16.0,
                        color: kCustomBlackColor,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ButtonTheme(
                      height: 50.0,
                      minWidth: MediaQuery.of(context).size.width * 60 / 100,
                      child: RoundButtonWidget(
                        text: 'COMPRAR AHORA',
                        onPressed: () {
                          Navigator.of(context).popUntil(
                            (route) => route.isFirst,
                          );
                        },
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SearchProductPage(),
                            ),
                          );
                        },
                        child: Image.asset(
                          'assets/icons/search.png',
                          width: 38.0,
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        'Búsquedas populares',
                        style: TextStyle(
                          fontSize: 18.0,
                          color: kCustomBlackColor,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Wrap(
                      verticalDirection: VerticalDirection.down,
                      alignment: WrapAlignment.center,
                      children: [
                        'arroz',
                        'aceite',
                        'leche',
                        'azúcar',
                        'chocolate',
                        'queso',
                      ].map((item) {
                        return Builder(builder: (BuildContext context) {
                          return GestureDetector(
                            child: ChipButtonWidget(
                              text: item,
                              onPressed: (text) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SearchProductPage(
                                      textToSearch: text,
                                    ),
                                  ),
                                );
                              },
                            ),
                          );
                        });
                      }).toList(),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
