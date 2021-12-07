import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:mercave/app/core/services/utils/alert/alert.service.dart';
import 'package:mercave/app/core/services/utils/loader/loader.service.dart';
import 'package:mercave/app/core/services/wordpress/wodpress.service.dart';

class UserFormController {
  Future updateUserInfo({
    @required BuildContext context,
    @required Map profile,
  }) async {
    AlertService.showConfirmAlert(
      context: context,
      title: 'Guardar',
      description: 'En realidad desea actualizar su información?',
      onTapCancel: () {},
      onTapOk: () async {
        LoaderService.showLoader(
          context: context,
          text: 'Creando su cuenta...',
        );

        Map profileData = {
          'name': profile['first_name'] + ' ' + profile['last_name'],
          'first_name': profile['first_name'],
          'last_name': profile['last_name'],
          'email': profile['email'],
        };

        if (profile['password'].length > 0) {
          profileData['password'] = profile['password'];
        }

        try {
          /// ==================================================================
          /// Update wordPress user info
          /// ==================================================================
          Map wordPressUser = await WordPressService.updateWordPressUser(
            userId: profile['id'],
            profile: profileData,
          );

          Map userData = {
            'id': wordPressUser['id'],
            'first_name': wordPressUser['first_name'],
            'last_name': wordPressUser['last_name'],
            'email': wordPressUser['email'],
            'phone': profile['phone'],
          };

          /// ==================================================================
          /// Update wordPress meta user info
          /// ==================================================================
          dynamic metadata = {
            "celular": profile['phone'],
          };

          await WordPressService.updateWordPressUserMetadata(
            userId: profile['id'],
            metadata: metadata,
          );

          /// ==================================================================
          /// Update local user info
          /// ==================================================================
          await UserDBService.createUpdateUser(userData: userData);
          LoaderService.dismissLoader(context: context);

          AlertService.showErrorAlert(
              context: context,
              title: 'Información actualizada',
              description: 'La información ha sido actualizada exitosamente.',
              onClose: () {
                Navigator.pop(context);
              });
        } catch (e) {
          LoaderService.dismissLoader(context: context);

          AlertService.showErrorAlert(
            context: context,
            title: 'Error al actualizar la información del usuario',
            description: e.message,
          );
        }
      },
    );
  }
}
