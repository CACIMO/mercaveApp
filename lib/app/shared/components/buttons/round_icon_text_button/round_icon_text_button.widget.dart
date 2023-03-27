import 'package:flutter/material.dart';

class RoundIconTextButton extends StatelessWidget {
  final String text;
  final Icon icon;
  final Color backgroundColor;
  final Color textColor;
  final Function onTapped;

  RoundIconTextButton({
    @required this.text,
    @required this.icon,
    @required this.backgroundColor,
    @required this.textColor,
    this.onTapped,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onTapped();
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: <Widget>[
            icon,
            SizedBox(
              width: 20.0,
            ),
            Text(
              text,
              style: TextStyle(
                color: textColor,
              ),
            ),
          ],
        ),
      )/*,
      color: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(18.0),
      ),*/
    );
  }
}
