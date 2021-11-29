import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/buttons/increase_decrease_button/increase_decrease_button.widget.ui.dart';

class IncreaseDecreaseButton extends StatelessWidget {
  final int quantity;
  final Function onDecreased;
  final Function onIncreased;

  IncreaseDecreaseButton({
    this.quantity,
    this.onDecreased,
    this.onIncreased,
  });

  @override
  Widget build(BuildContext context) {
    return IncreaseDecreaseButtonUI(
      context: context,
      quantity: quantity,
      onDecreased: onDecreased,
      onIncreased: onIncreased,
    ).build();
  }
}
