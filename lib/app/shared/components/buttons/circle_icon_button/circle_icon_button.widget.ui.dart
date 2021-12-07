import 'package:flutter/material.dart';

class CircleIconButtonWidgetUI {
  final BuildContext context;
  final Color backgroundColor;
  final IconData icon;
  final Color iconColor;

  CircleIconButtonWidgetUI({
    this.context,
    this.backgroundColor,
    this.icon,
    this.iconColor,
  });

  build() {
    return Container(
      width: 35.0,
      height: 35.0,
      decoration: new BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
      ),
      child: Icon(
        icon,
        size: 30.0,
        color: iconColor,
      ),
    );
  }
}
