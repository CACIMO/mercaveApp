import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mercave/app/ui/constants.dart';

class StepThree extends StatefulWidget {
  Function getData;
  String paymentMethod;
  bool paymentMethodError;

  StepThree(
      {key,
      @required this.getData,
      @required this.paymentMethod,
      @required this.paymentMethodError})
      : super(key: key);

  @override
  _StepThreeState createState() => _StepThreeState();
}

/// This is the private State class that goes with StepThree.
class _StepThreeState extends State<StepThree> {
  var _formThree = GlobalKey<FormState>();
  int paymentMethodValue;

  @override
  initState() {
    super.initState();

    if (widget.paymentMethod != null) loadStepData(widget.paymentMethod);
  }

  loadStepData(String paymentMethodSelected) {
    switch (paymentMethodSelected) {
      case 'online':
        paymentMethodValue = 0;
        break;

      case 'cash':
        paymentMethodValue = 1;
        break;

      case 'dataphone':
        paymentMethodValue = 2;
        break;
    }
  }

  void radioButtonChecked(int value) {
    setState(() {
      paymentMethodValue = value;

      switch (value) {
        case 0:
          widget.paymentMethod = 'online';
          break;

        case 1:
          widget.paymentMethod = 'cash';
          break;

        case 2:
          widget.paymentMethod = 'dataphone';
          break;
      }
    });

    widget.getData(widget.paymentMethod);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
          key: _formThree,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Text(
                  'Metodo',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    color: kCustomPrimaryColor,
                  ),
                ),
              ),
              Column(
                children: [
                  RadioListTile(
                    value: 0,
                    groupValue: paymentMethodValue,
                    onChanged: radioButtonChecked,
                    title: Text('En linea'),
                    activeColor: kCustomPrimaryColor,
                  ),
                  RadioListTile(
                    value: 1,
                    groupValue: paymentMethodValue,
                    onChanged: radioButtonChecked,
                    title: Text('Efectivo'),
                    activeColor: kCustomPrimaryColor,
                  ),
                  RadioListTile(
                    value: 2,
                    groupValue: paymentMethodValue,
                    onChanged: radioButtonChecked,
                    title: Text('Datáfono'),
                    activeColor: kCustomPrimaryColor,
                  ),
                  Visibility(
                    visible: widget.paymentMethodError,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(left: 30.0, bottom: 10.0),
                          child: Text(
                            'Debe seleccionar un metodo de pago',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              _getPaySafeWithWidget(context: context)
            ],
          )),
    );
  }

  Widget _getPaySafeWithWidget({BuildContext context}) {
    return Stack(
      children: [
        new Container(
          height: 90.0,
          color: kCustomWhiteColor,
        ),
        Positioned(
          left: 0.0,
          right: 0.0,
          top: 0.0,
          bottom: 0.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.lock,
                    color: Color(0xFF7cb124),
                  ),
                  SizedBox(width: 10.0),
                  Text(
                    'Pago seguro con:',
                    style: TextStyle(
                      color: kCustomStrongGrayColor,
                    ),
                  ),
                  SizedBox(width: 5.0),
                  Image.asset(
                    'assets/icons/pse.jpg',
                    height: 50.0,
                  ),
                  Image.asset(
                    'assets/icons/efecty.jpg',
                    height: 50.0,
                  )
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
