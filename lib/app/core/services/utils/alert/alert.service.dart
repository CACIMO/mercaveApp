import 'package:flutter/material.dart';

class AlertService {
  static Future showErrorAlert({
    BuildContext context,
    String title,
    String description,
    Function onClose,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        content: Text(
          description,
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');

              if (onClose != null) {
                onClose();
              }
            },
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  static Future showDynamicErrorAlert({
    BuildContext context,
    Widget title,
    Widget description,
    Function onClose,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: title,
        content: description,
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).pop('dialog');

              if (onClose != null) {
                onClose();
              }
            },
            child: Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  static Future showConfirmAlert({
    BuildContext context,
    String title,
    String description,
    Function onTapOk,
    Function onTapCancel,
  }) async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              AlertService.dismissAlert(context: context);

              if (onTapCancel != null) {
                onTapCancel();
              }
            },
            child: Text('No'),
          ),
          TextButton(
            onPressed: () {
              AlertService.dismissAlert(context: context);

              if (onTapOk != null) {
                onTapOk();
              }
            },
            child: Text(
              'Si',
              style: TextStyle(
                color: Colors.red,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Future showNoLoginAlert({
    BuildContext context,
    String title,
    String description,
    Function onTapLogin,
    Function onTapRegister,
  }) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        title: Text(
          title,
          style: TextStyle(
            color: Colors.red,
          ),
        ),
        content: Text(description),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              AlertService.dismissAlert(context: context);

              if (onTapLogin != null) {
                onTapLogin();
              }
            },
            child: Text('Ingresar'),
          ),
          TextButton(
            onPressed: () {
              AlertService.dismissAlert(context: context);

              if (onTapRegister != null) {
                onTapRegister();
              }
            },
            child: Text('Registrarme'),
          ),
        ],
      ),
    );
  }

  static dismissAlert({BuildContext context}) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }
}
