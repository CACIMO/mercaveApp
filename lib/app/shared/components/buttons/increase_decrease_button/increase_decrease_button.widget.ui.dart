import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mercave/app/ui/constants.dart';

class IncreaseDecreaseButtonUI {
  final BuildContext context;
  final int quantity;
  final Function onDecreased;
  final Function onIncreased;

  IncreaseDecreaseButtonUI({
    this.context,
    this.quantity,
    this.onDecreased,
    this.onIncreased,
  });

  build() {
    List button = [];

    if (quantity > 0) {
      button = <Widget>[
        getDecreaseButtonWidget(),
        getQuantityTextWidget(),
        getIncreaseButtonWidget(),
      ];
    } else {
      button = <Widget>[
        getAddTextButton(),
      ];
    }

    return Container(
      decoration: getIncreaseDecreaseButtonDecoration(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: button,
      ),
    );
  }

  getDecreaseButtonWidget() {
    Color buttonColor = quantity > 0 ? kCustomPrimaryColor : kCustomGrayColor;

    return ButtonTheme(
      minWidth: 10.0,
      child: TextButton(
        onPressed: onDecreased,
        child: Container(
          child: Icon(
            FontAwesomeIcons.minus,
            size: 10.0,
            color: buttonColor,
          ),
        ),
      ),
    );
  }

  getIncreaseButtonWidget() {
    return ButtonTheme(
      minWidth: 10.0,
      child: TextButton(
        onPressed: onIncreased,
        child: Container(
          child: Icon(
            FontAwesomeIcons.plus,
            size: 10.0,
            color: kCustomPrimaryColor,
          ),
        ),
      ),
    );
  }

  getQuantityTextWidget() {
    return Text(
      quantity.toString(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 20.0,
        color: kCustomPrimaryColor,
      ),
    );
  }

  getAddTextButton() {
    return TextButton(
      child: Text(
        'Agregar',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: kCustomWhiteColor,
        ),
      ),
      onPressed: () {
        onIncreased();
      },
    );
  }

  getIncreaseDecreaseButtonDecoration() {
    Color buttonColor = quantity > 0 ? Colors.white : kCustomPrimaryColor;

    return BoxDecoration(
      border: Border.all(
        color: kCustomPrimaryColor,
        width: 1.0,
      ),
      borderRadius: BorderRadius.circular(25.0),
      color: buttonColor,
    );
  }
}
