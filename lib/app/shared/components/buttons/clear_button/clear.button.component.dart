import 'package:flutter/material.dart';
import 'package:mercave/app/ui/constants.dart';

class ClearButtonComponent extends StatelessWidget {
  final String text;
  final Function onPressed;

  ClearButtonComponent({
    @required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: onPressed ?? () {},
        child: Text(
          text,
          style: TextStyle(
            color: kCustomPrimaryColor,
          ),
        ),
        style: ButtonStyle(
            backgroundColor:
                MaterialStateProperty.all<Color>(kCustomWhiteColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
              10.0,
            )))));
  }
}
