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
    return ElevatedButton(
      onPressed: onPressed ?? () {},
      //color: kCustomPrimaryColor,
      child: Text(
        text,
        style: TextStyle(
          color: kCustomWhiteColor,
        ),
      ),
     /* shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          10.0,
        ),
      ),*/
    );
  }
}
