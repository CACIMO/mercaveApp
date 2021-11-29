import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/buttons/chip_button/chip_button.widget.ui.dart';

class ChipButtonWidget extends StatelessWidget {
  final String text;
  final Function onPressed;

  ChipButtonWidget({
    this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ChipButtonWidgetUI(
      context: context,
      text: text,
      onPressed: onPressed,
    ).build();
  }
}
