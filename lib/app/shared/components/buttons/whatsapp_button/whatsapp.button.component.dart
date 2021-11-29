import 'package:flutter/material.dart';
import 'package:mercave/app/ui/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsAppButtonComponent extends StatefulWidget {
  final bool showAnimatedWhatsApp;

  WhatsAppButtonComponent({this.showAnimatedWhatsApp});

  @override
  _WhatsAppButtonComponentState createState() =>
      _WhatsAppButtonComponentState();
}

class _WhatsAppButtonComponentState extends State<WhatsAppButtonComponent> {
  double _width = 20.0;
  double _height = 20.0;

  final tooltipKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    animate();
  }

  void animate() {
    if (widget.showAnimatedWhatsApp != null && widget.showAnimatedWhatsApp) {
      Future.delayed(const Duration(milliseconds: 1000), () {
        final dynamic tooltip = tooltipKey.currentState;
        tooltip.ensureTooltipVisible();

        setState(() {
          _width = 38;
          _height = 38;
        });
      });
    } else {
      setState(() {
        _width = 38;
        _height = 38;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        key: tooltipKey,
        preferBelow: true,
        height: 15,
        padding: EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: kCustomPrimaryColor,
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        message: 'lo que desees vé 😎',
        textStyle: TextStyle(
          fontSize: 12.0,
          color: kCustomWhiteColor,
        ),
        child: InkWell(
          onTap: () async {
            var whatsAppUrl =
                "whatsapp://send?phone=+573194445306&text=Tengo la siguiente consulta...";

            if (await canLaunch(whatsAppUrl)) {
              launch(whatsAppUrl);
            }
          },
          child: AnimatedContainer(
            width: _width,
            height: _height,
            duration: Duration(milliseconds: 600),
            curve: Curves.easeInOut,
            child: Image.asset(
              'assets/icons/whatsapp.png',
            ),
          ),
        ));
  }
}
