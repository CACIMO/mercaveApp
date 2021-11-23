import 'package:flutter/material.dart';
import 'package:mercave/app/shared/components/titles/titles.widget.ui.dart';

class TitlesWidget extends StatelessWidget {
  final String leftTitle;
  final String rightTitle;
  final Function onRightTitleTapped;

  TitlesWidget({
    this.leftTitle = '',
    this.rightTitle = '',
    this.onRightTitleTapped,
  });

  @override
  Widget build(BuildContext context) {
    return TitlesWidgetUI(
      context: context,
      leftTitle: leftTitle,
      rightTitle: rightTitle,
      onRightTitleTapped: onRightTitleTapped,
    ).build();
  }
}
