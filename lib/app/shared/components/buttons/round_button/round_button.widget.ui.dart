import 'package:flutter/material.dart';

import '../../../../ui/constants.dart';

class RoundButtonWidgetUI {
  final BuildContext context;
  final String text;
  final Function onPressed;
  final Color textColor;
  final Color backgroundColor;
  final double fontSize;

  Color textColorItem;
  Color backgroundColorItem;

  RoundButtonWidgetUI({
    this.context,
    this.text,
    this.onPressed,
    this.textColor,
    this.backgroundColor,
    this.fontSize,
  }) {
    textColorItem = textColor != null ? textColor : kCustomSecondaryColor;
    backgroundColorItem =
        backgroundColor != null ? backgroundColor : kCustomPrimaryColor;
  }

  build() {
    return TextButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(backgroundColorItem),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40.0),
          ))),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 8.0),
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize ?? 18.0,
            color: textColorItem,
          ),
        ),
      ),
      onPressed: onPressed,
    );
  }
}
