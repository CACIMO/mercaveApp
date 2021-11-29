import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/pages/store/cart/payment_method/payment_method.controller.dart';
import 'package:mercave/app/shared/components/buttons/round_button/round_button.widget.dart';
import 'package:mercave/app/ui/constants.dart';

class PaymentMethodPage extends StatefulWidget {
  @override
  _PaymentMethodState createState() => _PaymentMethodState();
}

class _PaymentMethodState extends State<PaymentMethodPage> {
  static final String uponDeliveryPaymentMethodKey = 'upon-delivery';
  static final String cashUponDeliveryPaymentMethodKey = 'cash';
  static final String dataPhoneUponDeliveryPaymentMethodKey = 'dataphone';
  static final String defaultDeliveryPaymentMethodKey = 'default';

  static final String onlineDeliveryPaymentMethodKey = 'online';
  static final String naturalPersonClientKey = 'natural_person';
  static final String legalPersonClientKey = 'legal_person';

  final _formKey = GlobalKey<FormState>();
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;
  int userId;

  String paymentMethodSelected;
  String subPaymentMethodSelected = cashUponDeliveryPaymentMethodKey;
  String typeClientSelected = naturalPersonClientKey;
  String typeIdSelected = 'CC';

  Map userBilledData = {
    'user_id': '',
    'full_name': '',
    'identification_type': '',
    'identification_number': ''
  };

  Map paymentMethods = {
    uponDeliveryPaymentMethodKey: [
      cashUponDeliveryPaymentMethodKey,
      dataPhoneUponDeliveryPaymentMethodKey
    ],
    onlineDeliveryPaymentMethodKey: []
  };

  Map clientTypes = {
    naturalPersonClientKey: {
      'name': 'Persona',
      'document_types': ['CC', 'CE', 'PP']
    },
    legalPersonClientKey: {
      'name': 'Empresa',
      'document_types': ['NIT', 'RUT'],
    },
  };

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() async {
    int userId = await AuthService.getUserIdLogged();
    Map userData = await UserDBService.getUserById(id: userId);

    userBilledData = {
      'user_id': userId,
      'full_name': userData['billing_name'],
      'identification_type': userData['billing_identification_type'],
      'identification_number': userData['billing_identification_number']
    };

    if (userData['billing_name'] != null) {
      typeIdSelected = userData['billing_identification_type'];
      paymentMethodSelected = userData['payment_method'];
      subPaymentMethodSelected = userData['subpayment_method'];
      typeClientSelected = userData['client_type'];
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomPrimaryColor),
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: _getAppBarWidget(context),
        body: _getBodyWidget(context),
        bottomNavigationBar: _getPaySafeWithWidget(context: context),
      ),
    );
  }

  Widget _getAppBarWidget(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kCustomWhiteColor,
      title: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Row(
              children: <Widget>[
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Image.asset(
                    'assets/icons/back_arrow.png',
                    width: 25.0,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                Text(
                  'Elegir método de pago',
                  style: TextStyle(
                    color: kCustomBlackColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          _getPaymentMethodsWidget(context: context),
          _getBillFormWidget(context: context),
        ],
      ),
    );
  }

  Widget _getPaymentMethodsWidget({BuildContext context}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        _getOnlinePaymentMethodWidget(context: context),
        _getUponDeliveryPaymentMethodWidget(context: context),
      ],
    );
  }

  Widget _getOnlinePaymentMethodWidget({BuildContext context}) {
    bool visible = paymentMethodSelected == null ||
        paymentMethodSelected == onlineDeliveryPaymentMethodKey;

    Color textColor = kCustomStrongGrayColor;
    FontWeight textWeight = FontWeight.normal;

    if (paymentMethodSelected == onlineDeliveryPaymentMethodKey) {
      textColor = kCustomPrimaryColor;
      textWeight = FontWeight.bold;
    }

    return Visibility(
      visible: visible,
      child: Column(
        children: <Widget>[
          SizedBox(height: 30.0),
          Visibility(
            visible: paymentMethodSelected == null,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  paymentMethodSelected = onlineDeliveryPaymentMethodKey;
                  subPaymentMethodSelected = defaultDeliveryPaymentMethodKey;
                });
              },
              child: Image.asset(
                'assets/icons/pago_en_linea.png',
                width: 150.0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: paymentMethodSelected != null,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/icons/pago_en_linea.png',
                        width: 50.0,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Pago en línea',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: textColor,
                      fontWeight: textWeight,
                    ),
                  ),
                  Visibility(
                    visible: paymentMethodSelected != null,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          paymentMethodSelected = null;
                          subPaymentMethodSelected = null;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Cambiar método de pago',
                          style: TextStyle(
                            color: kCustomLinkColor,
                            decoration: TextDecoration.underline,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _getUponDeliveryPaymentMethodWidget({BuildContext context}) {
    bool visible = paymentMethodSelected == null ||
        paymentMethodSelected == uponDeliveryPaymentMethodKey;

    Color textColor = kCustomStrongGrayColor;
    FontWeight textWeight = FontWeight.normal;

    if (paymentMethodSelected == uponDeliveryPaymentMethodKey) {
      textColor = kCustomPrimaryColor;
      textWeight = FontWeight.bold;
    }

    return Visibility(
      visible: visible,
      child: Column(
        children: <Widget>[
          SizedBox(height: 30.0),
          Visibility(
            visible: paymentMethodSelected == null,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  paymentMethodSelected = uponDeliveryPaymentMethodKey;
                  subPaymentMethodSelected = cashUponDeliveryPaymentMethodKey;
                });
              },
              child: Image.asset(
                'assets/icons/pago_contraentrega.png',
                width: 150.0,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Visibility(
                visible: paymentMethodSelected != null,
                child: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Column(
                    children: <Widget>[
                      Image.asset(
                        'assets/icons/pago_contraentrega.png',
                        width: 50.0,
                      ),
                    ],
                  ),
                ),
              ),
              Column(
                children: <Widget>[
                  Text(
                    'Pago contraentrega',
                    style: TextStyle(
                      fontSize: 20.0,
                      color: textColor,
                      fontWeight: textWeight,
                    ),
                  ),
                  Visibility(
                    visible: paymentMethodSelected != null,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          paymentMethodSelected = null;
                          subPaymentMethodSelected = null;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          'Cambiar método de pago',
                          style: TextStyle(
                            color: kCustomLinkColor,
                            decoration: TextDecoration.underline,
                            fontSize: 20.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          _getUponDeliverySubPaymentMethodWidget(context: context),
        ],
      ),
    );
  }

  Widget _getUponDeliverySubPaymentMethodWidget({BuildContext context}) {
    bool visible = paymentMethodSelected == uponDeliveryPaymentMethodKey;

    Color cashButtonColor = kCustomWhiteColor;
    Color cashTextColor = kCustomPrimaryColor;

    Color dataPhoneButtonColor = kCustomWhiteColor;
    Color dataPhoneTextColor = kCustomPrimaryColor;

    if (subPaymentMethodSelected == cashUponDeliveryPaymentMethodKey) {
      cashButtonColor = kCustomPrimaryColor;
      cashTextColor = kCustomSecondaryColor;
    }

    if (subPaymentMethodSelected == dataPhoneUponDeliveryPaymentMethodKey) {
      dataPhoneButtonColor = kCustomPrimaryColor;
      dataPhoneTextColor = kCustomSecondaryColor;
    }

    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.only(top: 20.0),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 1,
              child: TextButton(
                style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        EdgeInsets.symmetric(vertical: 12.0)),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(cashButtonColor)),
                onPressed: () {
                  setState(() {
                    subPaymentMethodSelected = cashUponDeliveryPaymentMethodKey;
                  });
                },
                child: Text(
                  'Efectivo',
                  style: TextStyle(
                    color: cashTextColor,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            SizedBox(width: 2.0),
            Expanded(
              flex: 1,
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(vertical: 12.0)),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(dataPhoneButtonColor),
                ),
                onPressed: () {
                  setState(() {
                    subPaymentMethodSelected =
                        dataPhoneUponDeliveryPaymentMethodKey;
                  });
                },
                child: Text(
                  'Datáfono',
                  style: TextStyle(
                    color: dataPhoneTextColor,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getBillFormWidget({BuildContext context}) {
    bool visible = (paymentMethodSelected == uponDeliveryPaymentMethodKey &&
            subPaymentMethodSelected != null) ||
        paymentMethodSelected == onlineDeliveryPaymentMethodKey;

    Color personButtonColor = kCustomWhiteColor;
    Color personTextColor = kCustomPrimaryColor;

    Color companyButtonColor = kCustomWhiteColor;
    Color companyTextColor = kCustomPrimaryColor;

    if (typeClientSelected == naturalPersonClientKey) {
      personButtonColor = kCustomPrimaryColor;
      personTextColor = kCustomSecondaryColor;
    }

    if (typeClientSelected == legalPersonClientKey) {
      companyButtonColor = kCustomPrimaryColor;
      companyTextColor = kCustomSecondaryColor;
    }

    return Visibility(
      visible: visible,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              '¡Ya estamos acabando!',
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 7.0),
            Text(
              'Confirmanos los datos para tu factura, de acuerdo con la '
              'resolución 30 de 2019 título II Artículo 2',
              style: TextStyle(
                fontSize: 13.0,
              ),
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: ButtonTheme(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RoundButtonWidget(
                        text: 'Persona',
                        textColor: personTextColor,
                        backgroundColor: personButtonColor,
                        fontSize: 14.0,
                        onPressed: () {
                          setState(() {
                            typeClientSelected = naturalPersonClientKey;
                            typeIdSelected = 'CC';
                            userBilledData['identification_type'] = 'CC';
                          });
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: ButtonTheme(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: RoundButtonWidget(
                        text: 'Empresa',
                        textColor: companyTextColor,
                        backgroundColor: companyButtonColor,
                        fontSize: 14.0,
                        onPressed: () {
                          setState(() {
                            typeClientSelected = legalPersonClientKey;
                            typeIdSelected = 'NIT';
                            userBilledData['identification_type'] = 'NIT';
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Form(
                key: _formKey,
                autovalidateMode: _autoValidate,
                child: Column(
                  children: <Widget>[
                    _getFullNameField(context: context),
                    _getDocumentTypeField(context: context),
                    _getDocumentNumberField(context: context),
                    _getSaveButton(context: context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _getFullNameField({BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        initialValue: this.userBilledData['full_name'],
        cursorColor: kCustomPrimaryColor,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: typeClientSelected == 'natural_person'
              ? 'Ingresa el nombre completo'
              : 'Ingresa el nombre de la empresa',
          labelText: typeClientSelected == 'natural_person'
              ? 'Nombre Completo *'
              : 'Nombre de la empresa *',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          fillColor: kCustomWhiteColor,
          focusColor: kCustomWhiteColor,
          filled: true,
        ),
        validator: (value) {
          if (value.length < 3) {
            return 'Por favor ingrese el nombre completo';
          }
          return null;
        },
        onSaved: (String value) {
          setState(() {
            this.userBilledData['full_name'] = value;
          });
        },
      ),
    );
  }

  Widget _getDocumentTypeField({BuildContext context}) {
    List<String> documentTypes;

    if (typeClientSelected != null && typeIdSelected != null) {
      documentTypes = clientTypes[typeClientSelected]['document_types'];

      return Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: DropdownButtonFormField(
          isDense: true,
          value: typeIdSelected,
          items: documentTypes.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: (value) {
            setState(() {
              typeIdSelected = value;
              this.userBilledData['identification_type'] = value;
            });
          },
          decoration: InputDecoration(
            hintText: 'Selecciona el tipo de documento',
            labelText: 'Tipo Documento',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            fillColor: kCustomWhiteColor,
            focusColor: kCustomWhiteColor,
            filled: true,
          ),
          validator: (value) {
            if (value == null) {
              return 'Por favor seleccione el tipo de documento';
            }
            return null;
          },
          onSaved: (String value) {
            setState(() {
              this.userBilledData['identification_type'] = typeIdSelected;
            });
          },
        ),
      );
    }

    return SizedBox();
  }

  Widget _getDocumentNumberField({BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        initialValue: this.userBilledData['identification_number'],
        cursorColor: kCustomPrimaryColor,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Ingresa el número de documento',
          labelText: 'Número Documento',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          fillColor: kCustomWhiteColor,
          focusColor: kCustomWhiteColor,
          filled: true,
        ),
        validator: (value) {
          if (value.length < 3) {
            return 'Por favor ingrese el número de identificación';
          }
          return null;
        },
        onSaved: (String value) {
          setState(() {
            this.userBilledData['identification_number'] = value;
          });
        },
      ),
    );
  }

  Widget _getSaveButton({BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(50.0, 20.0, 50.0, 20.0),
      child: ButtonTheme(
        height: 50.0,
        minWidth: MediaQuery.of(context).size.width,
        child: RoundButtonWidget(
          text: 'GUARDAR',
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              print(userBilledData);

              PaymentMethodController().savePaymentMethodInfo(
                context: context,
                userBilledData: userBilledData,
                paymentMethodSelected: paymentMethodSelected,
                subPaymentMethodSelected: subPaymentMethodSelected,
                typeClientSelected: typeClientSelected,
              );
            } else {
              setState(() {
                _autoValidate = AutovalidateMode.always;
              });
            }
          },
        ),
      ),
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
          child: Padding(
            padding: const EdgeInsets.only(top: 16.0),
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
        ),
      ],
    );
  }
}
