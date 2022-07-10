import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:mercave/app/shared/constants/constant.service.dart';
import 'package:mercave/app/ui/constants.dart';

class GatewayPage extends StatefulWidget {
  final String checkoutUrl;
  final String orderId;

  GatewayPage({@required this.checkoutUrl, @required this.orderId});

  @override
  _GatewayPageState createState() => _GatewayPageState();
}

class _GatewayPageState extends State<GatewayPage> {
  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.checkoutUrl,
      appBar: new AppBar(
        backgroundColor: kCustomPrimaryColor,
        automaticallyImplyLeading: false,
        title: Row(
          children: <Widget>[
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Image.asset(
                'assets/icons/back_arrow.png',
                color: kCustomWhiteColor,
                width: 25.0,
              ),
            ),
            SizedBox(width: 10.0),
            Text('Pasarela: Pedido No. ' + widget.orderId.toString()),
          ],
        ),
      ),
      withZoom: false,
      withLocalStorage: true,
      hidden: true,
      withJavascript: true,
      allowFileURLs: true,
      initialChild: Container(
        color: kCustomWhiteColor,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Text(
                  'Espera un momento por favor mientras cargamos '
                  'la pasarela de pago.....',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: kCustomPrimaryColor,
                  ),
                ),
              ),
              SpinKitChasingDots(
                color: kCustomPrimaryColor,
                size: 50.0,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
