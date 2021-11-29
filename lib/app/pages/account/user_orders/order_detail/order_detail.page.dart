import 'package:flutter/material.dart';
import 'package:mercave/app/pages/account/user_orders/order_detail/order_detail.controller.dart';
import 'package:mercave/app/pages/store/product/product_detail/product_detail.page.dart';
import 'package:mercave/app/shared/components/buttons/round_button/round_button.widget.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/shared/components/store/product_list_item/product_list_item.widget.dart';
import 'package:mercave/app/shared/utils/string/string.service.dart';
import 'package:mercave/app/ui/constants.dart';

class OrderDetailPage extends StatefulWidget {
  final Map order;

  OrderDetailPage({this.order});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  bool error = false;
  bool loading = false;

  Map order;
  List products = [];

  @override
  void initState() {
    super.initState();
    _init();
  }

  void _init() async {
    setState(() {
      error = false;
      loading = true;
    });

    try {
      Map orderData = await OrderDetailController().getOrderInfo(
        orderId: widget.order['id'],
      );

      order = orderData['order'];
      products = orderData['products'];

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
        body: _getOrderProductList(context: context),
        bottomNavigationBar: Stack(
          children: [
            new Container(
              height: 100.0,
              color: kCustomPrimaryColor,
            ),
            Positioned(
              left: 0.0,
              right: 0.0,
              top: 0.0,
              bottom: 0.0,
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
                              color: kCustomWhiteColor,
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
                            StringService.getPriceFormat(
                                number: double.tryParse(widget.order['total'])),
                            textAlign: TextAlign.right,
                            style: TextStyle(
                              fontSize: 18.0,
                              color: kCustomWhiteColor,
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
                        child: RoundButtonWidget(
                          text: 'Crear canasta',
                          textColor: kCustomPrimaryColor,
                          backgroundColor: kCustomWhiteColor,
                          onPressed: () {
                            OrderDetailController().createCartBasedOnOrder(
                              context: context,
                              orderId: order['id'],
                            );
                          },
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
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
                  'Pedido No. ' + widget.order['number'],
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

  Widget _getOrderProductList({BuildContext context}) {
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

    String dateCreated = widget.order['date_created'];
    dateCreated = dateCreated.replaceAll('T', ' ');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Creado',
                          style: TextStyle(
                            color: kCustomPrimaryColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(dateCreated),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Estado',
                          style: TextStyle(
                            color: kCustomPrimaryColor,
                            fontSize: 14.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(orderStatusTranslated[widget.order['status']]),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                width: 1.0,
                color: kCustomStrongGrayColor,
              ),
            ),
          ),
          height: MediaQuery.of(context).size.height * 5 / 100,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              products.length.toString() + ' productos',
              textAlign: TextAlign.end,
            ),
          ),
        ),
        Container(
          height: MediaQuery.of(context).size.height * 63.5 / 100,
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              return Column(
                children: <Widget>[
                  ProductListItemWidget(
                    product: products[index],
                    onProductDecreased: (product) {},
                    onProductIncreased: (product) {},
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
              );
            },
          ),
        ),
      ],
    );
  }
}
