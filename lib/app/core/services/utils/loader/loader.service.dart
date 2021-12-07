import 'package:flutter/material.dart';

class LoaderService {
  static Future showLoader({
    BuildContext context,
    String text,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () {
            return Future.value(false);
          },
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 25.0,
                    width: 25.0,
                    child: CircularProgressIndicator(),
                  ),
                  SizedBox(width: 15.0),
                  Text(text),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  static dismissLoader({BuildContext context}) {
    Navigator.of(context, rootNavigator: true).pop('dialog');
  }
}
