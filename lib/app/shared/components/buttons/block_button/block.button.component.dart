import 'package:flutter/material.dart';
import 'package:mercave/app/ui/constants.dart';

class BlockButtonComponent extends StatelessWidget {
  final String text;
  final Function onPressed;

  BlockButtonComponent({
    @required this.text,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(kCustomPrimaryColor),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)))),
      onPressed: onPressed ?? () {},
      child: Text(
        text,
        style: TextStyle(
          color: kCustomWhiteColor,
        ),
      ),
    );
  }
}
