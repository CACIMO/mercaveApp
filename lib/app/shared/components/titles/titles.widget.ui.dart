import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mercave/app/ui/constants.dart';

class TitlesWidgetUI {
  final BuildContext context;
  final String leftTitle;
  final String rightTitle;
  final double viewportFraction = 0.9;
  final Function onRightTitleTapped;

  double screenWidth;
  double horizontalPadding;

  TitlesWidgetUI({
    this.context,
    this.leftTitle,
    this.rightTitle,
    this.onRightTitleTapped,
  }) {
    setDimensions();
  }

  build() {
    bool visible = leftTitle != '' || rightTitle != '';

    return Visibility(
      visible: visible,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(2.0, 16.0, 2.0, 0.0),
          child: Row(
            children: <Widget>[
              getLeftTitleWidget(),
              getRightTitleWidget(),
            ],
          ),
        ),
      ),
    );
  }

  getLeftTitleWidget() {
    bool visible = leftTitle != '';

    return Visibility(
      visible: visible,
      child: Expanded(
        child: Column(
          children: <Widget>[
            Text(
              leftTitle,
              style: TextStyle(
                fontSize: 17.0,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
      ),
    );
  }

  getRightTitleWidget() {
    bool visible = rightTitle != '';

    return Visibility(
      visible: visible,
      child: Expanded(
        child: InkWell(
          onTap: onRightTitleTapped,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Text(
                rightTitle,
                style: TextStyle(
                  fontSize: 15.0,
                  color: kCustomPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Icon(
                FontAwesomeIcons.caretRight,
                color: kCustomPrimaryColor,
              ),
            ],
          ),
        ),
      ),
    );
  }

  setDimensions() {
    screenWidth = MediaQuery.of(context).size.width;
    horizontalPadding = (screenWidth - screenWidth * viewportFraction) / 2;
  }
}
