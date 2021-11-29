import 'package:flutter/material.dart';
import 'package:mercave/app/ui/constants.dart';

class ChipButtonWidgetUI {
  final BuildContext context;
  final String text;
  final Function onPressed;

  ChipButtonWidgetUI({
    this.context,
    this.text,
    this.onPressed,
  });

  build() {
    return Container(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
        child: ActionChip(
          shadowColor: kCustomPrimaryColor,
          onPressed: () {
            onPressed(text);
          },
          padding: EdgeInsets.symmetric(
            horizontal: 8.0,
            vertical: 10.0,
          ),
          label: Text(
            text,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}
