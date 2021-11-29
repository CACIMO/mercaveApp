import 'package:mercave/app/core/services/sqlite/sqlite.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/cart/cart.model.dart';

class CartDBService {
  static final String table = 'cart';
  static final String scheme = "CREATE TABLE IF NOT EXISTS $table("
      " id INTEGER PRIMARY KEY AUTOINCREMENT, "
      " description TEXT "
      ")";

  static createCart(Cart newCart) async {
    final db = await SQLiteService.db.database;
    var res = await db.insert(table, newCart.toMap());
    return res;
  }

  static getCart(int id) async {
    final db = await SQLiteService.db.database;
    var res = await db.query(table, where: "id = ?", whereArgs: [id]);
    return res.isNotEmpty ? Cart.fromMap(res.first) : Null;
  }

  static deleteCart(int id) async {
    final db = await SQLiteService.db.database;
    db.delete(table, where: "id = ?", whereArgs: [id]);
  }

  static updateCart(Cart cart) async {
    final db = await SQLiteService.db.database;
    var res = await db
        .update(table, cart.toMap(), where: "id = ?", whereArgs: [cart.id]);
    return res;
  }
}
