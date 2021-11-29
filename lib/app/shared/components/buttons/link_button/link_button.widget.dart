import 'package:flutter/material.dart';
import 'package:mercave/app/ui/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkButtonWidget extends StatelessWidget {
  final String text;
  final String url;
  final double fontSize;

  LinkButtonWidget({
    @required this.text,
    @required this.url,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (await canLaunch(url)) {
          await launch(url, forceSafariVC: false);
        }
      },
      child: Text(
        text,
        style: TextStyle(
          fontSize: fontSize ?? 10.0,
          color: kCustomLinkColor,
        ),
      ),
    );
  }
}
