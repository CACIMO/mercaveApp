import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/core/services/utils/loader/loader.service.dart';
import 'package:mercave/app/core/services/wordpress/wodpress.service.dart';
import 'package:mercave/app/pages/account/user_menu/user_menu.page.dart';
import 'package:mercave/app/shared/components/buttons/link_button/link_button.widget.dart';

class LoginController {
  void login({
    @required BuildContext context,
    @required String email,
    @required String password,
  }) async {
    LoaderService.showLoader(
      context: context,
      text: 'Ingresando...',
    );

    try {
      Map wordPressUser = await WordPressService.getWordPressUserByEmail(
        email: email,
      );

      if (wordPressUser == null) {
        LoaderService.dismissLoader(context: context);

        AlertService.showErrorAlert(
          context: context,
          title: 'Error al ingresar',
          description:
              'El correo ingresado no se encuentra asociado a una cuenta.',
        );

        return;
      }

      await WordPressService.getUserToken(
        username: email,
        password: password,
      );

      String avatar = '';
      try {
        avatar = wordPressUser['avatar_urls']['96'];
      } catch (e) {}

      Map userData = {
        'id': wordPressUser['id'],
        'first_name': wordPressUser['first_name'],
        'last_name': wordPressUser['last_name'],
        'email': wordPressUser['email'],
        'avatar': avatar,
        'phone': wordPressUser['acf']['celular'],
        'neighborhood': wordPressUser['acf']['barrio'],
        'type_of_road': wordPressUser['acf']['via'],
        'plate_part_1': wordPressUser['acf']['placa_no_1'],
        'plate_part_2': wordPressUser['acf']['placa_no_2'],
        'plate_part_3': wordPressUser['acf']['placa_no_3'],
        'address_info': wordPressUser['acf']['informacion_direccion'],
      };

      await UserDBService.createUpdateUser(userData: userData);
      await AuthService.setUserIdLogged(userId: wordPressUser['id']);

      LoaderService.dismissLoader(context: context);
      goToUserHomePage(context: context);
    } catch (e) {
      LoaderService.dismissLoader(context: context);

      if (e.details['code'] == '[jwt_auth] incorrect_password') {
        AlertService.showDynamicErrorAlert(
          context: context,
          title: Text(
            'Contraseña invalida',
            style: TextStyle(
              color: Colors.red,
            ),
          ),
          description: Container(
            height: 160.0,
            child: Column(
              children: <Widget>[
                Text(e.message),
                SizedBox(height: 20.0),
                LinkButtonWidget(
                  text: 'Recupera tu contraseña',
                  url: 'https://www.mercave.com.co/mi-cuenta/lost-password/',
                  fontSize: 16.0,
                ),
              ],
            ),
          ),
        );
      } else {
        AlertService.showErrorAlert(
          context: context,
          title: 'Error al ingresar',
          description: e.message,
        );
      }
    }
  }

  void goToUserHomePage({BuildContext context}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => UserMenuPage(),
      ),
    );
  }
}
