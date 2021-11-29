import 'package:mercave/app/core/services/exception/exception.service.dart';
import 'package:mercave/app/core/services/sqlite/sqlite.service.dart';

class LocalStorageDBService {
  static final String table = 'local_storage';
  static final String scheme = "CREATE TABLE IF NOT EXISTS $table("
      " key TEXT PRIMARY KEY, "
      " value TEXT "
      ")";

  static Future setItem({String key, String value}) async {
    String query;

    try {
      var db = await SQLiteService.db.database;
      bool itemExists = await LocalStorageDBService.itemExist(key: key);

      if (itemExists) {
        query = 'UPDATE $table SET value = ? WHERE key = ?;';
        await db.rawUpdate(query, [value, key]);
      } else {
        query = 'INSERT INTO $table(key, value) VALUES (?, ?);';
        await db.rawInsert(query, [key, value]);
      }
    } catch (e) {
      (e);
      return Future.error(ExceptionService.databaseException(message: e));
    }

    return Future.value(true);
  }

  static Future getItem({String key}) async {
    String value;

    try {
      final db = await SQLiteService.db.database;
      String query = 'SELECT value FROM $table WHERE key = ?;';
      List items = await db.rawQuery(query, [key]);

      if (items.length == 1) {
        value = items[0]['value'];
      }
    } catch (e) {
      return Future.error(ExceptionService.databaseException(message: e));
    }

    return Future.value(value);
  }

  static Future removeItem({String key}) async {
    try {
      final db = await SQLiteService.db.database;
      String query = 'DELETE FROM $table WHERE key = ?;';
      await db.rawDelete(query, [key]);
    } catch (e) {
      return Future.error(ExceptionService.databaseException(message: e));
    }

    return Future.value(true);
  }

  static Future clear() async {
    try {
      final db = await SQLiteService.db.database;
      String query = 'DELETE FROM $table;';
      await db.rawDelete(query, []);
    } catch (e) {
      return Future.error(ExceptionService.databaseException(message: e));
    }

    return Future.value(true);
  }

  static Future itemExist({String key}) async {
    bool itemExists = false;

    try {
      final db = await SQLiteService.db.database;
      String query = 'SELECT * FROM $table WHERE key = ?;';
      List items = await db.rawQuery(query, [key]);

      if (items.length == 1) {
        itemExists = true;
      }
    } catch (e) {
      return Future.error(ExceptionService.databaseException(message: e));
    }

    return Future.value(itemExists);
  }
}
