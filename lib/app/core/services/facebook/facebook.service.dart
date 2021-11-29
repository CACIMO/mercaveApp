import 'dart:convert' as JSON;

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:mercave/app/core/services/exception/exception.service.dart';

class FacebookService {
  static final facebookLogin = FacebookLogin();
  static final String graphUrl =
      'https://graph.facebook.com/v2.12/me?fields=first_name,last_name,middle_name,name,email,picture&access_token=';

  static Future login() async {
    String errorMessage;
    dynamic profile;
    await facebookLogin.logOut();
    // Let's force the users to login using the login dialog based on WebViews. Yay!
    facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
    final result = await facebookLogin.logIn(['email']); //Version 3.0.0
    // final result = await facebookLogin.logInWithReadPermissions(['email']); //Version 2.0.0
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;

        final graphResponse = await http.get(graphUrl + token);
        profile = JSON.jsonDecode(graphResponse.body);
        break;

      case FacebookLoginStatus.cancelledByUser:
        break;
      case FacebookLoginStatus.error:
        errorMessage = result.errorMessage;
        break;
    }

    if (errorMessage != null) {
      return Future.error(ExceptionService.httpException(
        statusCode: -1,
        message: errorMessage,
      ));
    }

    return Future.value(profile);
  }
}
