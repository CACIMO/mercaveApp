import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';

class HomeController {
  Future quitApp({BuildContext context}) async {
    await AlertService.showConfirmAlert(
      context: context,
      title: 'Salir de la aplicación?',
      description: 'En realidad desea salir de la aplicación?',
      onTapCancel: () {},
      onTapOk: () {
        SystemNavigator.pop();
      },
    );

    return Future.value(false);
  }
}
