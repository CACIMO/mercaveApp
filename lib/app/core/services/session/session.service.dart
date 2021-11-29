import 'package:mercave/app/core/services/sqlite/tables/_local_storage/local_storage.db.service.dart';

class SessionService {
  static Future setItem({String key, String value}) async {
    try {
      await LocalStorageDBService.setItem(
        key: key,
        value: value,
      );
    } catch (e) {
      return Future.error(e);
    }

    return Future.value(true);
  }

  static Future getItem({String key}) async {
    String value;

    try {
      value = await LocalStorageDBService.getItem(
        key: key,
      );
    } catch (e) {
      return Future.error(e);
    }

    return Future.value(value);
  }

  static Future removeItem({String key}) async {
    try {
      await LocalStorageDBService.removeItem(key: key);
      return Future.value(true);
    } catch (e) {
      return Future.error(e);
    }
  }

  static Future clear() async {
    try {
      return await LocalStorageDBService.clear();
    } catch (e) {
      return Future.error(e);
    }
  }
}
