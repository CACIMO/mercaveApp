import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/utils/validator/validator.service.dart';
import 'package:mercave/app/pages/account/login/login.controller.dart';
import 'package:mercave/app/pages/account/register/register.page.dart';
import 'package:mercave/app/shared/components/buttons/block_button/block.button.component.dart';
import 'package:mercave/app/shared/components/buttons/clear_button/clear.button.component.dart';
import 'package:mercave/app/ui/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  String _email = '';
  String _password = '';

  bool _hidePasswordText = true;
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomPrimaryColor),
      home: Scaffold(
        backgroundColor: kCustomWhiteColor,
        appBar: _getAppBarWidget(context: context),
        body: _getBody(context: context),
      ),
    );
  }

  Widget _getAppBarWidget({BuildContext context}) {
    return AppBar(
      title: Text(''),
      backgroundColor: Colors.transparent,
      elevation: 0,
      titleSpacing: 0.0,
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color: kCustomPrimaryColor,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
  }

  Widget _getBody({BuildContext context}) {
    return Center(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Container(
                  decoration: new BoxDecoration(
                    color: kCustomWhiteColor,
                    borderRadius: new BorderRadius.all(Radius.circular(15.0)),
                  ),
                  child: Form(
                    key: _formKey,
                    autovalidate: _autoValidate,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(children: <Widget>[
                        _getHeaderLogo(context: context),
                        _getEmailField(context: context),
                        _getPasswordField(context: context),
                        _getLoginButton(context: context),
                        _getRegisterButton(context: context),
                      ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getHeaderLogo({BuildContext context}) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Image.asset(
            'assets/logo-mercave.jpg',
            width: MediaQuery.of(context).size.width * 40 / 100,
          ),
        ),
      ],
    );
  }

  Widget _getEmailField({BuildContext context}) {
    return TextFormField(
      cursorColor: kCustomPrimaryColor,
      keyboardType: TextInputType.emailAddress,
      decoration: const InputDecoration(
        icon: Icon(
          Icons.email,
          color: kCustomPrimaryColor,
        ),
        hintText: 'Ingresa tu e-mail',
        labelText: 'e-mail *',
      ),
      validator: (value) {
        if (!ValidatorService.isEmailValid(value)) {
          return 'Por favor ingrese un e-mail valido';
        }
        return null;
      },
      onSaved: (String value) {
        _email = value;
      },
    );
  }

  Widget _getPasswordField({BuildContext context}) {
    return TextFormField(
      cursorColor: kCustomPrimaryColor,
      keyboardType: TextInputType.visiblePassword,
      obscureText: _hidePasswordText,
      decoration: InputDecoration(
        icon: Icon(
          Icons.lock,
          color: kCustomPrimaryColor,
        ),
        hintText: 'Ingresa tu contraseña',
        labelText: 'contraseña *',
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
        _password = value;
      },
    );
  }

  Widget _getLoginButton({BuildContext context}) {
    return Container(
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
      child: BlockButtonComponent(
        text: 'Ingresar',
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            _formKey.currentState.save();

            LoginController().login(
              context: context,
              email: _email,
              password: _password,
            );
          } else {
            setState(() {
              _autoValidate = true;
            });
          }
        },
      ),
    );
  }

  Widget _getRegisterButton({BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(0.0),
      width: MediaQuery.of(context).size.width,
      child: ClearButtonComponent(
        text: 'Crear cuenta',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => RegisterPage()),
          );
        },
      ),
    );
  }
}
