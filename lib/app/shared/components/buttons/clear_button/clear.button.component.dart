import 'package:flutter/material.dart';
import 'package:mercave/app/ui/constants.dart';

class ClearButtonComponent extends StatelessWidget {
  final String text;
  final Function onPressed;

  ClearButtonComponent({
    @required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: onPressed ?? () {},
      color: kCustomWhiteColor,
      child: Text(
        text,
        style: TextStyle(
          color: kCustomPrimaryColor,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),
    );
  }
}
