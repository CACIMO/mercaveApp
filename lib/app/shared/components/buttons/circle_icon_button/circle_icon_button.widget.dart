import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/buttons/circle_icon_button/circle_icon_button.widget.ui.dart';

class CircleIconButtonWidget extends StatelessWidget {
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  CircleIconButtonWidget({
    this.backgroundColor,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return CircleIconButtonWidgetUI(
      context: context,
      backgroundColor: backgroundColor,
      icon: icon,
      iconColor: iconColor,
    ).build();
  }
}
