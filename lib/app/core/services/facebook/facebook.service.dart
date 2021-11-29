/* import 'dart:convert' as JSON;

import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:http/http.dart' as http;
import 'package:mercave/app/core/services/exception/exception.service.dart'; */

class FacebookService {
  /* 
  static final facebookLogin = FacebookLogin();
  static final String graphUrl =
      "v2.12/me?fields=first_name,last_name,middle_name,name,email,picture&access_token=";
  static final String faceDomain = "graph.facebook.com";

  static Future login() async {
    String errorMessage;
    dynamic profile;
    await facebookLogin.logOut();

    final result = await facebookLogin.logIn(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        final token = result.accessToken.token;

        final graphResponse =
            await http.get(Uri.https(faceDomain, '$graphUrl$token'));
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
  } */
}
