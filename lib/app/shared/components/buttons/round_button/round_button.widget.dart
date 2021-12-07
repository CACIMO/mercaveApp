import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/buttons/round_button/round_button.widget.ui.dart';

class RoundButtonWidget extends StatelessWidget {
  final String text;
  final Function onPressed;
  final Color textColor;
  final Color backgroundColor;
  final double fontSize;

  const RoundButtonWidget({
    this.text,
    this.onPressed,
    this.textColor,
    this.backgroundColor,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return RoundButtonWidgetUI(
      context: context,
      text: text,
      onPressed: onPressed,
      textColor: textColor,
      backgroundColor: backgroundColor,
      fontSize: fontSize,
    ).build();
  }
}
