import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/auth/auth.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/core/services/utils/loader/loader.service.dart';
import 'package:mercave/app/core/services/wordpress/wodpress.service.dart';
import 'package:mercave/app/pages/account/user_menu/user_menu.page.dart';

class RegisterController {
  void createUser({BuildContext context, Map formData}) async {
    AlertService.showConfirmAlert(
      context: context,
      title: 'Crear cuenta?',
      description: 'En realidad desea crear su cuenta?',
      onTapOk: () async {
        LoaderService.showLoader(
          context: context,
          text: 'Creando su cuenta...',
        );

        Map profile = {
          'username': formData['email'] + Random().nextInt(1000).toString(),
          'name': formData['first_name'] + ' ' + formData['last_name'],
          'first_name': formData['first_name'],
          'last_name': formData['last_name'],
          'email': formData['email'],
          'password': formData['password'],
          'roles': 'customer',
        };

        try {
          /// ==================================================================
          /// Create the wordPress user
          /// ==================================================================
          Map wordPressUser =
              await WordPressService.createWordPressUser(profile: profile);

          String avatar = '';
          try {
            avatar = wordPressUser['avatar_urls']['96'];
          } catch (e) {}

          /// ==================================================================
          /// Update wordPress meta user info
          /// ==================================================================
          dynamic metadata = {
            "celular": formData['phone'],
          };

          await WordPressService.updateWordPressUserMetadata(
            userId: wordPressUser['id'],
            metadata: metadata,
          );

          /// ==================================================================
          /// Create the local user
          /// ==================================================================
          Map userData = {
            'id': wordPressUser['id'],
            'first_name': wordPressUser['first_name'],
            'last_name': wordPressUser['last_name'],
            'phone': formData['phone'],
            'email': wordPressUser['email'],
            'avatar': avatar
          };

          await UserDBService.createUpdateUser(userData: userData);
          await AuthService.setUserIdLogged(userId: wordPressUser['id']);

          LoaderService.dismissLoader(context: context);
          goToUserHomePage(context: context);
        } catch (e) {
          LoaderService.dismissLoader(context: context);
          AlertService.showErrorAlert(
            context: context,
            title: 'Error al crear el usuario',
            description: e.toString(),
          );
        }
      },
    );
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
