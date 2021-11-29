import 'package:flutter/material.dart';
import 'package:mercave/app/ui/constants.dart';

class StepFour extends StatefulWidget {
  GlobalKey formKey;
  String customerType;
  bool customerTypeError;
  Map userBilledData;
  Function getData;
  Function saveData;

  StepFour({
    @required this.formKey,
    @required this.customerType,
    @required this.customerTypeError,
    @required this.userBilledData,
    @required this.getData,
    @required this.saveData,
  });

  @override
  _StepFourState createState() => _StepFourState();
}

class _StepFourState extends State<StepFour> {
  int customerTypeValue;

  String typeIdSelected;
  static final String naturalPersonClientKey = 'natural_person';
  static final String legalPersonClientKey = 'legal_person';

  Map userBilledData = {
    'user_id': '',
    'full_name': '',
    'identification_type': '',
    'identification_number': ''
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
  // Responsive parameter
  bool inputIsDense = false;
  double mainFontSize = 20.0;
  double paddingCustomerTypeWidget = 20;
  double paddingCustomerTypeWidgetInner = 7;
  double paddingBillFormWidget = 15;
  double paddingBillFormWidgetField = 8;

  @override
  initState() {
    super.initState();

    if (widget.customerType != null) {
      loadStepData(widget.customerType);
    }

    userBilledData = widget.userBilledData;
    typeIdSelected = userBilledData['identification_type'];
  }

  loadStepData(String customerTypeSelected) {
    switch (customerTypeSelected) {
      case 'natural_person':
        customerTypeValue = 0;
        break;

      case 'legal_person':
        customerTypeValue = 1;
        break;
    }
  }

  void radioButtonChecked(int value) {
    setState(() {
      customerTypeValue = value;

      switch (value) {
        case 0:
          widget.customerType = naturalPersonClientKey;
          typeIdSelected = 'CC';
          userBilledData['identification_type'] = 'CC';
          break;

        case 1:
          widget.customerType = legalPersonClientKey;
          typeIdSelected = 'NIT';
          userBilledData['identification_type'] = 'NIT';
          break;
      }
    });

    widget.getData(widget.customerType);
  }

  @override
  Widget build(BuildContext context) {
    //Responsive check
    double deviceHeight = MediaQuery.of(context).size.height;
    if (deviceHeight < 667 && deviceHeight >= 592) {
      inputIsDense = true;
      mainFontSize = 16;
      paddingCustomerTypeWidget = 5;
      paddingCustomerTypeWidgetInner = 0;
      paddingBillFormWidget = 0;
      paddingBillFormWidgetField = 7;
    }
    return Column(children: <Widget>[
      _getCustomerTypeWidget(context: context),
      _getBillFormWidget(context: context)
    ]);
  }

  Widget _getCustomerTypeWidget({BuildContext context}) {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            '¡Ya estamos acabando!',
            style: TextStyle(
              fontSize: mainFontSize,
            ),
          ),
          SizedBox(height: paddingCustomerTypeWidgetInner),
          Text(
            'Confirmanos los datos para tu factura, de acuerdo con la '
            'resolución 30 de 2019 título II Artículo 2',
            style: TextStyle(
              fontSize: 13.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: paddingCustomerTypeWidget),
            child: Text(
              'Tipo de cliente',
              textAlign: TextAlign.left,
              style: TextStyle(
                color: kCustomPrimaryColor,
              ),
            ),
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  child: RadioListTile(
                    dense: inputIsDense,
                    value: 0,
                    groupValue: customerTypeValue,
                    onChanged: radioButtonChecked,
                    title: Text('Persona'),
                    activeColor: kCustomPrimaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  child: RadioListTile(
                    dense: inputIsDense,
                    value: 1,
                    groupValue: customerTypeValue,
                    onChanged: radioButtonChecked,
                    title: Text('Empresa'),
                    activeColor: kCustomPrimaryColor,
                  ),
                ),
              ),
            ],
          ),
          Visibility(
            visible: widget.customerTypeError,
            child: Row(
              children: [
                Container(
                  margin: EdgeInsets.only(left: 30.0, bottom: 10.0),
                  child: Text(
                    'Debe seleccionar un tipo de cliente',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ]);
  }

  Widget _getBillFormWidget({BuildContext context}) {
    return Expanded(
      child: Visibility(
        visible: widget.customerType != null,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                bottom: paddingBillFormWidget, left: 15.0, right: 15.0),
            child: Padding(
              padding: const EdgeInsets.only(left: 6),
              child: Form(
                key: widget.formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    _getFullNameField(context: context),
                    _getDocumentTypeField(context: context),
                    _getDocumentNumberField(context: context),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getFullNameField({BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(top: paddingBillFormWidgetField),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: this.userBilledData['full_name'],
        cursorColor: kCustomPrimaryColor,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          isDense: inputIsDense,
          hintText: widget.customerType == 'natural_person'
              ? 'Ingresa el nombre completo'
              : 'Ingresa el nombre de la empresa',
          labelText: widget.customerType == 'natural_person'
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
            widget.saveData(userBilledData);
          });
        },
      ),
    );
  }

  Widget _getDocumentTypeField({BuildContext context}) {
    List<String> documentTypes;

    if (widget.customerType != null && typeIdSelected != null) {
      documentTypes = clientTypes[widget.customerType]['document_types'];

      return Padding(
        padding: EdgeInsets.only(top: paddingBillFormWidgetField),
        child: DropdownButtonFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
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
            isDense: inputIsDense,
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
              widget.saveData(userBilledData);
            });
          },
        ),
      );
    }

    return SizedBox();
  }

  Widget _getDocumentNumberField({BuildContext context}) {
    return Padding(
      padding: EdgeInsets.only(top: paddingBillFormWidgetField),
      child: TextFormField(
        autovalidateMode: AutovalidateMode.onUserInteraction,
        initialValue: this.userBilledData['identification_number'],
        cursorColor: kCustomPrimaryColor,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          isDense: inputIsDense,
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
            widget.saveData(userBilledData);
          });
        },
      ),
    );
  }
}
