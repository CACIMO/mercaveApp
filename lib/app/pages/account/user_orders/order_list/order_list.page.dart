import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mercave/app/core/services/api/woocommerce/order/wc_order.api.service.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/pages/account/user_orders/order_detail/order_detail.page.dart';
import 'package:mercave/app/pages/store/product/search_product/search_product.page.dart';
import 'package:mercave/app/shared/components/buttons/chip_button/chip_button.widget.dart';
import 'package:mercave/app/shared/components/buttons/round_button/round_button.widget.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';

class OrderListPage extends StatefulWidget {
  @override
  _OrderListPageState createState() => _OrderListPageState();
}

class _OrderListPageState extends State<OrderListPage> {
  List<dynamic> orders = [];
  ScrollController scrollController = new ScrollController();

  bool error = false;
  bool loading = false;

  bool noMoreOrders = false;
  bool loadingMoreOrders = false;
  int offset = 0;

  @override
  void initState() {
    super.initState();
    _init();
    _initScrollController();
  }

  void _init() async {
    setState(() {
      error = false;
      loading = true;
    });

    try {
      int userId = await AuthService.getUserIdLogged();
      orders = await WCOrderAPIService().getOrdersByUserId(userId: userId);

      setState(() {
        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = true;
        error = true;
      });
    }
  }

  void _initScrollController() {
    setState(() {
      noMoreOrders = false;
      loadingMoreOrders = false;
      offset = 0;
    });

    scrollController.addListener(() async {
      double currentScrollPosition = scrollController.position.pixels;
      double maxScrollPosition = scrollController.position.maxScrollExtent;

      if (!noMoreOrders &&
          !loadingMoreOrders &&
          currentScrollPosition == maxScrollPosition) {
        setState(() {
          offset += 10;
          loadingMoreOrders = true;
        });

        try {
          List<dynamic> moreOrders = [];
          int userId = await AuthService.getUserIdLogged();
          moreOrders = await WCOrderAPIService()
              .getOrdersByUserId(userId: userId, offset: offset);

          if (moreOrders.length < 10) {
            setState(() {
              noMoreOrders = true;
            });
          }

          setState(() {
            orders.addAll(moreOrders);
            loadingMoreOrders = false;
          });
        } catch (e) {
          setState(() {
            loadingMoreOrders = false;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading || error) {
      return PageLoaderWidget(
        error: error,
        onError: () async {
          _init();
        },
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomWhiteColor),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: _getAppBarWidget(context: context),
        body: _orderListWidget(context: context),
      ),
    );
  }

  Widget _getAppBarWidget({BuildContext context}) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
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
          ),
          Expanded(
            flex: 8,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Tus pedidos',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _orderListWidget({BuildContext context}) {
    if (orders.length > 0) {
      return ListView.separated(
        controller: scrollController,
        itemCount: orders.length,
        separatorBuilder: (context, index) => Divider(
          color: kCustomStrongGrayColor,
          height: 1.0,
        ),
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Column(
              children: <Widget>[
                _getOrderListItem(context: context, order: orders[index]),
                Visibility(
                  visible: loadingMoreOrders && orders.length == (index + 1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Cargando más pedidos...',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: kCustomPrimaryColor,
                            fontSize: 12.0,
                          ),
                        ),
                        SizedBox(
                          width: 5.0,
                        ),
                        SpinKitChasingDots(
                          color: kCustomPrimaryColor,
                          size: 25.0,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            trailing: Icon(
              Icons.chevron_right,
              size: 30.0,
              color: Colors.black,
            ),
          );
        },
      );
    } else {
      return _getEmptyCartWidget(context: context);
    }
  }

  Widget _getOrderListItem({BuildContext context, dynamic order}) {
    Map orderStatusTranslated = {
      'pending': 'Pendiente',
      'processing': 'En Proceso',
      'on-hold': 'En Espera',
      'completed': 'Completado',
      'cancelled': 'Cancelado',
      'refunded': 'Reintegrado',
      'failed': 'Fallido',
      'trash': 'Reciclado'
    };

    return ListTile(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => OrderDetailPage(order: order),
          ),
        );
      },
      title: Text(
        'Order No. ' + order['number'],
        style: TextStyle(
          color: kCustomPrimaryColor,
        ),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Estado: ' + orderStatusTranslated[order['status']],
            textAlign: TextAlign.left,
          ),
          Text(
            'Total: ' +
                StringService.getPriceFormat(
                  number: double.tryParse(
                    order['total'],
                  ),
                ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }

  Widget _getEmptyCartWidget({BuildContext context}) {
    return SingleChildScrollView(
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
                  'Aún no has realizado ningún pedido',
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
    );
  }
}
