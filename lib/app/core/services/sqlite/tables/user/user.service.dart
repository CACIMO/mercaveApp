import 'package:mercave/app/core/services/exception/exception.service.dart';
import 'package:mercave/app/core/services/sqlite/sqlite.service.dart';

class UserDBService {
  static final String table = 'user';
  static final String scheme = "CREATE TABLE IF NOT EXISTS $table("
      " id INTEGER PRIMARY KEY, "
      " first_name TEXT, "
      " last_name TEXT, "
      " avatar TEXT,"
      " email TEXT, "
      " phone TEXT, "
      " neighborhood TEXT, "
      " type_of_road TEXT, "
      " plate_part_1 TEXT, "
      " plate_part_2 TEXT, "
      " plate_part_3 TEXT, "
      " address_info TEXT, "
      " payment_method TEXT, "
      " subpayment_method TEXT, "
      " client_type TEXT, "
      " billing_name TEXT, "
      " billing_identification_type TEXT, "
      " billing_identification_number TEXT "
      ")";

  static Future createUpdateUser({Map userData}) async {
    try {
      Map user = await UserDBService.getUserById(
        id: userData['id'],
      );

      if (user != null) {
        await UserDBService.updateUser(
          id: userData['id'],
          userData: userData,
        );
      } else {
        await UserDBService.createUser(userData: userData);
      }
    } catch (e) {
      Future.error(e);
    }

    return Future.value(true);
  }

  static Future getUserById({int id}) async {
    Map user;

    try {
      final db = await SQLiteService.db.database;
      String query = 'SELECT * FROM $table WHERE id = ?;';
      List users = await db.rawQuery(query, [id]);

      if (users.length == 1) {
        user = users[0];
      }
    } catch (e) {
      return Future.error(
        ExceptionService.databaseException(
          message: e.message,
        ),
      );
    }

    return Future.value(user);
  }

  static Future createUser({Map userData}) async {
    try {
      final db = await SQLiteService.db.database;
      List fields = [];
      List values = [];
      List slots = [];

      userData.forEach((key, value) {
        fields.add(key);
        values.add(value);
        slots.add('?');
      });

      var query = 'INSERT INTO $table(' +
          fields.join(', ') +
          ') VALUES(' +
          slots.join(', ') +
          ');';
      await db.rawInsert(query, values);
    } catch (e) {
      return Future.error(
        ExceptionService.databaseException(
          message: e,
        ),
      );
    }

    return Future.value(true);
  }

  static Future updateUser({int id, Map userData}) async {
    userData.remove('id');

    try {
      final db = await SQLiteService.db.database;
      List fieldsValues = [];
      List values = [];
      List slots = ['?'];

      userData.forEach((key, value) {
        fieldsValues.add('$key = ?');
        values.add(value);
        slots.add('?');
      });
      values.add(id);

      var query =
          'UPDATE $table SET ' + fieldsValues.join(', ') + ' WHERE id = ?;';
      await db.rawUpdate(query, values);
    } catch (e) {
      return Future.error(
        ExceptionService.databaseException(
          message: e,
        ),
      );
    }

    return Future.value(true);
  }
}
