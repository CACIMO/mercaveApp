import 'dart:convert';

import 'package:mercave/app/core/services/http/http.service.dart';
import 'package:mercave/app/shared/constants/constant.service.dart';

class WordPressService {
  static final String _managerUsername = 'mercaveadmin';
  static final String _managerPassword = '7xCx!rUmd@mHTHq9IAKKTld5';
  static final String _slugToken = 'wp-json/jwt-auth/v1/token';
  static final String _wordPressApiRestUrl = 'wp-json/wp/v2';

  /// ==========================================================================
  /// Get the user token to allow make operations using the wordPress REST API.
  /// These operations include: create a user, read a user, etc.
  ///
  /// This functions uses the credentials of an user with those privileges.
  /// ==========================================================================
  static Future getUserToken({
    String username,
    String password,
  }) async {
    try {
      var response = await HttpService.post(
        url: _slugToken,
        body: {
          'username': username,
          'password': password,
        },
      );
      return Future.value(response['token']);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future createUserWithFacebookUserData({Map profile}) async {
    try {
      Map userCreated;
      String username = "fb_" + profile['id'];

      String firstName = profile['first_name'];
      if (profile['middle_name'] != null) {
        firstName += profile['middle_name'];
      }

      Map profileInfo = {
        'username': username,
        'name': profile['name'],
        'first_name': firstName,
        'last_name': profile['last_name'],
        'email': profile['email'],
        'roles': 'customer',
        'password': "mercave"
      };

      userCreated = await WordPressService.getWordPressUserByUsername(
        username: profile['email'],
      );

      if (userCreated == null) {
        userCreated = await WordPressService.createWordPressUser(
          profile: profileInfo,
        );
      }

      return Future.value(userCreated);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future createWordPressUser({Map profile}) async {
    var user;
    try {
      String managerToken = await WordPressService.getUserToken(
        username: _managerUsername,
        password: _managerPassword,
      );
      Map<String, String> headers = {
        'Authorization': 'Bearer $managerToken',
      };

      user = await HttpService.post(
        url: '$_wordPressApiRestUrl/users',
        headers: headers,
        body: profile,
      );

      return Future.value(user);
    } catch (e) {
      print("Error:");
      print(e);
      return Future.error(e);
    }
  }

  static Future updateWordPressUser({int userId, Map profile}) async {
    var user;
    try {
      String managerToken = await WordPressService.getUserToken(
        username: _managerUsername,
        password: _managerPassword,
      );
      Map<String, String> headers = {
        'Authorization': 'Bearer $managerToken',
      };

      user = await HttpService.post(
        url: '$_wordPressApiRestUrl/users/$userId',
        headers: headers,
        body: profile,
      );

      return Future.value(user);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future updateWordPressUserMetadata({int userId, Map metadata}) async {
    try {
      String managerToken = await WordPressService.getUserToken(
        username: _managerUsername,
        password: _managerPassword,
      );
      Map<String, String> headers = {
        'Authorization': 'Bearer $managerToken',
        'Content-Type': 'application/json'
      };

      await HttpService.post(
        url: 'wp-json/acf/v3/users/$userId',
        headers: headers,
        body: json.encode({
          "fields": metadata,
        }),
      );

      return Future.value(true);
    } catch (e) {
      print('Error2');
      print(e);
      return Future.error(e);
    }
  }

  static Future getWordPressUserByUsername({String username}) async {
    var userInfo;

    try {
      String url = '$_wordPressApiRestUrl/users?search=$username';
      String managerToken = await WordPressService.getUserToken(
        username: _managerUsername,
        password: _managerPassword,
      );

      Map<String, String> headers = {
        'Authorization': 'Bearer $managerToken',
      };

      List usersInfo = await HttpService.get(
        url: url,
        headers: headers,
      );

      if (usersInfo.length == 1) {
        userInfo = usersInfo[0];
      }
    } catch (e) {
      if (e.code == ConstantService.httpNotFoundCode) {
        return Future.value(null);
      }
      return Future.error(e);
    }

    return Future.value(userInfo);
  }

  /// ==========================================================================
  /// Search for user in wordPress with a specific email
  /// ==========================================================================
  static Future getWordPressUserByEmail({String email}) async {
    var userInfo;

    try {
      String url = '$_wordPressApiRestUrl/users?search=$email';
      String managerToken = await WordPressService.getUserToken(
        username: _managerUsername,
        password: _managerPassword,
      );

      Map<String, String> headers = {
        'Authorization': 'Bearer $managerToken',
      };

      List usersInfo = await HttpService.get(
        url: url,
        headers: headers,
      );

      for (var i = 0; i < usersInfo.length; i++) {
        if (usersInfo[i]['email'] == email) {
          userInfo = usersInfo[i];
        }
      }
    } catch (e) {
      if (e.code == ConstantService.httpNotFoundCode) {
        return Future.value(null);
      }
      return Future.error(e);
    }

    return Future.value(userInfo);
  }
}
