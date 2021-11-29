import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:mercave/app/shared/components/buttons/round_button/round_button.widget.dart';
import 'package:mercave/app/ui/constants.dart';

class PageLoaderWidgetUI {
  final BuildContext context;
  final bool error;
  final Function onError;

  const PageLoaderWidgetUI({
    this.context,
    this.error,
    this.onError,
  });

  build() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          getImageWidget(),
          getSpinnerWidget(),
          getErrorMessageWidget(),
        ],
      )),
    );
  }

  getImageWidget() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Image.asset(
        'assets/logo-mercave.jpg',
        width: 100.0,
      ),
    );
  }

  getSpinnerWidget() {
    return Visibility(
      visible: !error,
      child: Column(
        children: <Widget>[
          SpinKitChasingDots(
            color: kCustomPrimaryColor,
            size: 50.0,
          ),
        ],
      ),
    );
  }

  getErrorMessageWidget() {
    return Visibility(
      visible: error,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40.0),
        child: Column(
          children: <Widget>[
            Text(
              'Ha ocurrido un error al cargar la información. Compruebe su conexión a internet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: kCustomGrayTextColor,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RoundButtonWidget(
                onPressed: () {
                  onError();
                },
                text: 'Intentar de nuevo',
              ),
            )
          ],
        ),
      ),
    );
  }
}
