import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/utils/validator/validator.service.dart';
import 'package:mercave/app/pages/account/register/register.controller.dart';
import 'package:mercave/app/shared/components/buttons/round_button/round_button.widget.dart';
import 'package:mercave/app/ui/constants.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  RegisterController registerController;
  final _formKey = GlobalKey<FormState>();

  Map _registerFormData = {
    'first_name': '',
    'last_name': '',
    'phone': '',
    'email': '',
    'password': ''
  };

  bool _hidePasswordText = true;
  AutovalidateMode _autoValidate = AutovalidateMode.disabled;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomPrimaryColor),
      home: Scaffold(
        backgroundColor: kCustomWhiteColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Row(
            children: <Widget>[
              Expanded(
                flex: 1,
                child: Row(
                  children: <Widget>[
                    GestureDetector(
                      onTap: () => Navigator.pop(context, false),
                      child: Image.asset(
                        'assets/icons/back_arrow.png',
                        width: 25.0,
                        color: kCustomWhiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 8,
                child: Text('Crear Cuenta'),
              )
            ],
          ),
        ),
        body: _getBody(context: context),
      ),
    );
  }

  Widget _getBody({BuildContext context}) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          autovalidateMode: _autoValidate,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(children: <Widget>[
              _getFirstNameField(context: context),
              _getLastNameField(context: context),
              _getPhoneField(context: context),
              _getEmailField(context: context),
              _getPasswordField(context: context),
              _getCreateAccountButton(context: context)
            ]),
          ),
        ),
      ),
    );
  }

  Widget _getFirstNameField({BuildContext context}) {
    String title = 'Nombres (*)';
    String hintText = 'Ingresa tus nombres';

    if (_registerFormData['client_type'] == 'company') {
      title = 'Razón Social (*)';
      hintText = 'Ingresa el nombre de la empresa';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15.0),
        Text(
          title,
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          cursorColor: kCustomPrimaryColor,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
            hintText: hintText,
            alignLabelWithHint: true,
          ),
          validator: (value) {
            if (value.isEmpty || value.length < 3) {
              return 'Por favor ingresa un nombre valido';
            }
            return null;
          },
          onSaved: (String value) {
            _registerFormData['first_name'] = value;
          },
        ),
      ],
    );
  }

  Widget _getLastNameField({BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15.0),
        Text(
          'Apellidos (*)',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          cursorColor: kCustomPrimaryColor,
          keyboardType: TextInputType.text,
          decoration: const InputDecoration(
            hintText: 'Ingresa tus apellidos',
            alignLabelWithHint: true,
          ),
          validator: (value) {
            if (value.isEmpty || value.length < 3) {
              return 'Por favor ingresa un apellido valido';
            }
            return null;
          },
          onSaved: (String value) {
            _registerFormData['last_name'] = value;
          },
        ),
      ],
    );
  }

  Widget _getPhoneField({BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15.0),
        Text(
          'Teléfono/Celular (*)',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          cursorColor: kCustomPrimaryColor,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            hintText: 'Ingrese su teléfono/celular',
            alignLabelWithHint: true,
          ),
          validator: (value) {
            if (value.isEmpty || value.length < 7) {
              return 'Por favor ingresa un teléfono/celular valido';
            }
            return null;
          },
          onSaved: (String value) {
            _registerFormData['phone'] = value;
          },
        ),
      ],
    );
  }

  Widget _getEmailField({BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15.0),
        Text(
          'E-mail (*)',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          cursorColor: kCustomPrimaryColor,
          keyboardType: TextInputType.emailAddress,
          decoration: const InputDecoration(
            hintText: 'Ingrese su correo',
            alignLabelWithHint: true,
          ),
          validator: (value) {
            if (!ValidatorService.isEmailValid(value)) {
              return 'Por favor ingresa un correo valido';
            }
            return null;
          },
          onSaved: (String value) {
            _registerFormData['email'] = value;
          },
        ),
      ],
    );
  }

  Widget _getPasswordField({BuildContext context}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 15.0),
        Text(
          'Contraseña (*)',
          style: TextStyle(
            fontSize: 15.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        TextFormField(
          obscureText: _hidePasswordText,
          cursorColor: kCustomPrimaryColor,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            hintText: 'Ingrese su contraseña',
            alignLabelWithHint: true,
            suffixIcon: IconButton(
              icon: Icon(
                _hidePasswordText ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () {
                setState(() {
                  _hidePasswordText = !_hidePasswordText;
                });
              },
            ),
          ),
          validator: (value) {
            if (value.isEmpty) {
              return 'Por favor ingrese un contraseña valida';
            }
            if (value.length < 3) {
              return 'La contraseña debe tener mínimo 3 caracteres';
            }
            return null;
          },
          onSaved: (String value) {
            _registerFormData['password'] = value;
          },
        ),
      ],
    );
  }

  Widget _getCreateAccountButton({BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: RoundButtonWidget(
        text: 'Crear cuenta',
        textColor: kCustomWhiteColor,
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            RegisterController().createUser(
              context: context,
              formData: _registerFormData,
            );
          } else {
            setState(() {
              _autoValidate = AutovalidateMode.always;
            });
          }
        },
      ),
    );
  }
}
