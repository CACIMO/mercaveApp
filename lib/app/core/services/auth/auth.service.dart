import 'package:mercave/app/core/services/session/session.service.dart';

class AuthService {
  static const String USER_ID_LOGGED_KEY = 'user_id_logged';

  static Future setUserIdLogged({int userId}) async {
    try {
      await SessionService.setItem(
        key: USER_ID_LOGGED_KEY,
        value: userId.toString(),
      );
    } catch (e) {
      return Future.error(e);
    }

    return Future.value(true);
  }

  static Future getUserIdLogged() async {
    int userId = 0;

    try {
      String userIdStore = await SessionService.getItem(
        key: USER_ID_LOGGED_KEY,
      );

      if (userIdStore != null && int.tryParse(userIdStore) > 0) {
        userId = int.parse(userIdStore);
      }
    } catch (e) {
      return Future.error(e);
    }

    return Future.value(userId);
  }
}
