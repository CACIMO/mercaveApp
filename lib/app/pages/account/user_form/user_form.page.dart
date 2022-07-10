import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/core/services/utils/validator/validator.service.dart';
import 'package:mercave/app/pages/account/user_form/user_form.controller.dart';
import 'package:mercave/app/shared/components/buttons/round_button/round_button.widget.dart';
import 'package:mercave/app/shared/components/loaders/page_loader/page_loader.widget.dart';
import 'package:mercave/app/ui/constants.dart';

class UserFormPage extends StatefulWidget {
  @override
  _UserFormPageState createState() => _UserFormPageState();
}

class _UserFormPageState extends State<UserFormPage> {
  bool loading = false;
  bool error = false;

  final _formKey = GlobalKey<FormState>();
  bool _obscurePassword = true;
  bool _obscurePasswordConfirmation = true;

  Map userData = {
    'id': '',
    'first_name': '',
    'last_name': '',
    'phone': '',
    'email': '',
    'password': '',
    'password_confirmation': ''
  };

  bool _autoValidate = false;

  @override
  void initState() {
    super.initState();
    _getUserData();
  }

  void _getUserData() async {
    setState(() {
      loading = true;
      error = false;
    });

    int userId = await AuthService.getUserIdLogged();
    Map userData = await UserDBService.getUserById(id: userId);

    if (userData != null) {
      setState(() {
        this.userData = {
          'id': userData['id'],
          'first_name': userData['first_name'],
          'last_name': userData['last_name'],
          'avatar': userData['avatar'],
          'phone': userData['phone'],
          'email': userData['email'],
          'password': '',
          'password_confirmation': ''
        };
      });
    }

    setState(() {
      loading = false;
      error = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading || error) {
      return PageLoaderWidget(
        error: error,
        onError: () {
          _getUserData();
        },
      );
    }

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: kCustomPrimaryColor),
      home: Scaffold(
        backgroundColor: kCustomGrayColor,
        appBar: _getAppBarWidget(context),
        body: _getBodyWidget(context),
      ),
    );
  }

  Widget _getAppBarWidget(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: kCustomPrimaryColor,
      elevation: 0,
      title: Row(
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Image.asset('assets/icons/back_arrow.png',
                color: kCustomWhiteColor, width: 25.0),
          ),
          SizedBox(width: 10.0),
          Expanded(
            flex: 1,
            child: Text(
              'Mi Cuenta',
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 21.0,
                color: kCustomWhiteColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _getBodyWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          _getHeaderBackground(context: context),
          _getUserForm(context: context),
        ],
      ),
    );
  }

  Widget _getHeaderBackground({BuildContext context}) {
    return Stack(children: [
      Container(
        height: 230.0,
        color: kCustomWhiteColor,
        child: Column(
          children: <Widget>[
            Container(
              width: MediaQuery.of(context).size.width,
              height: 120.0,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/background_user_form.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ],
        ),
      ),
      new Positioned(
        top: 60.0,
        child: _getUserHeaderInfoWidget(context: context),
      ),
    ]);
  }

  Widget _getUserHeaderInfoWidget({BuildContext context}) {
    return Container(
      height: 180.0,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 60.0,
            backgroundColor: kCustomWhiteColor,
            backgroundImage: this.userData['avatar'] != null
                ? NetworkImage(this.userData['avatar'])
                : AssetImage('assets/icons/person.png'),
          ),
          SizedBox(height: 15.0),
          this.userData['first_name'] != null
              ? Text(
                  this.userData['first_name'],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                )
              : SizedBox(),
          SizedBox(height: 15.0),
        ],
      ),
    );
  }

  Widget _getUserForm({BuildContext context}) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: kCustomGrayBorderColor,
            width: 1.0,
          ),
        ),
        color: kCustomGrayColor,
      ),
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Form(
          key: _formKey,
          //autovalidate: _autoValidate,
          child: Column(
            children: <Widget>[
              SizedBox(height: 10.0),
              _getFirstNameField(context: context),
              _getLastNameField(context: context),
              _getPhoneField(context: context),
              _getEmailField(context: context),
              _getPasswordField(context: context),
              _getPasswordConfirmationField(context: context),
              _getSaveButton(context: context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getFirstNameField({BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: TextFormField(
        initialValue: this.userData['first_name'],
        cursorColor: kCustomPrimaryColor,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Ingresa tus nombres',
          labelText: 'Nombres *',
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
            return 'Por favor ingrese su(s) nombre(s)';
          }
          return null;
        },
        onSaved: (String value) {
          this.userData['first_name'] = value;
        },
      ),
    );
  }

  Widget _getLastNameField({BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextFormField(
        initialValue: this.userData['last_name'],
        cursorColor: kCustomPrimaryColor,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          hintText: 'Ingresa tus apellidos',
          labelText: 'Apellidos *',
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
            return 'Por favor ingrese su(s) apellidos(s)';
          }
          return null;
        },
        onSaved: (String value) {
          this.userData['last_name'] = value;
        },
      ),
    );
  }

  Widget _getPhoneField({BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextFormField(
        initialValue: this.userData['phone'],
        cursorColor: kCustomPrimaryColor,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          hintText: 'Ingresa tu celular/teléfono',
          labelText: 'Celular/Teléfono *',
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
          if (value.length < 7) {
            return 'Por favor ingresa un celular/teléfono valido';
          }
          return null;
        },
        onSaved: (String value) {
          this.userData['phone'] = value;
        },
      ),
    );
  }

  Widget _getEmailField({BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextFormField(
        initialValue: this.userData['email'],
        cursorColor: kCustomPrimaryColor,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Ingresa tu e-mail',
          labelText: 'Email *',
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
          if (!ValidatorService.isEmailValid(value)) {
            return 'Por favor ingresa un correo valido';
          }
          return null;
        },
        onSaved: (String value) {
          this.userData['email'] = value;
        },
      ),
    );
  }

  Widget _getPasswordField({BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextFormField(
        obscureText: _obscurePassword,
        cursorColor: kCustomPrimaryColor,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          hintText: 'Nueva contraseña',
          labelText: 'Nueva contraseña',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          fillColor: kCustomWhiteColor,
          focusColor: kCustomWhiteColor,
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
        validator: (value) {
          if (this.userData['password'] != '' &&
              this.userData['password'].length < 4) {
            return 'Por favor ingresa una contraseña mayor a 4 caracteres';
          }
          return null;
        },
        onSaved: (String value) {
          this.userData['password'] = value;
        },
        onChanged: (value) {
          this.userData['password'] = value;
        },
      ),
    );
  }

  Widget _getPasswordConfirmationField({BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextFormField(
        obscureText: _obscurePasswordConfirmation,
        cursorColor: kCustomPrimaryColor,
        keyboardType: TextInputType.visiblePassword,
        decoration: InputDecoration(
          hintText: 'Confirmar nueva contraseña',
          labelText: 'Confirmar nueva contraseña',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
          ),
          fillColor: kCustomWhiteColor,
          focusColor: kCustomWhiteColor,
          filled: true,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePasswordConfirmation
                  ? Icons.visibility_off
                  : Icons.visibility,
            ),
            onPressed: () {
              setState(() {
                _obscurePasswordConfirmation = !_obscurePasswordConfirmation;
              });
            },
          ),
        ),
        validator: (value) {
          if (this.userData['password_confirmation'] != '' &&
              this.userData['password_confirmation'].length < 4) {
            return 'Por favor ingresa una contraseña mayor a 4 caracteres';
          }

          if (this.userData['password'] !=
              this.userData['password_confirmation']) {
            return 'La contraseña de confirmación no coincide.';
          }
          return null;
        },
        onSaved: (String value) {
          this.userData['password_confirmation'] = value;
        },
        onChanged: (String value) {
          this.userData['password_confirmation'] = value;
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
          textColor: kCustomWhiteColor,
          onPressed: () async {
            if (_formKey.currentState.validate()) {
              _formKey.currentState.save();

              UserFormController().updateUserInfo(
                context: context,
                profile: userData,
              );
            } else {
              setState(() {
                _autoValidate = true;
              });
            }
          },
        ),
      ),
    );
  }
}
