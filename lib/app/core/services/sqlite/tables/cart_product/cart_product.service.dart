import 'package:mercave/app/core/services/exception/exception.service.dart';
import 'package:mercave/app/core/services/sqlite/sqlite.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/cart_product/cart_product.model.dart';

class CartProductDBService {
  static final String table = 'cart_product';
  static final String scheme = "CREATE TABLE IF NOT EXISTS $table("
      " product_id INTEGER NOT NULL, "
      " cart_id INTEGER NOT NULL, "
      " quantity INTEGER NOT NULL, "
      " price REAL NOT NULL, "
      " data TEXT NOT NULL, "
      " PRIMARY KEY (product_id, cart_id) "
      ")";

  static Future createCartProduct(CartProduct newCartProduct) async {
    final db = await SQLiteService.db.database;
    var res;

    try {
      db.delete(
        table,
        where: "cart_id = ? AND product_id = ?",
        whereArgs: [newCartProduct.cartId, newCartProduct.productId],
      );

      res = await db.insert(table, newCartProduct.toMap());
    } catch (e) {
      return Future.error(ExceptionService.databaseException(message: e));
    }
    return Future.value(res);
  }

  static Future updateCartProduct(CartProduct newCartProduct) async {
    final db = await SQLiteService.db.database;
    var res;
    try {
      res = await db.update(
        table,
        newCartProduct.toMap(),
        where: 'cart_id = ? AND product_id = ?',
        whereArgs: [newCartProduct.cartId, newCartProduct.productId],
      );
    } catch (e) {
      return Future.error(ExceptionService.databaseException(message: e));
    }
    return Future.value(res);
  }

  static Future deleteCartProduct({int cartId, int productId}) async {
    final db = await SQLiteService.db.database;

    try {
      db.delete(table,
          where: "cart_id = ? AND product_id = ?",
          whereArgs: [cartId, productId]);
    } catch (e) {
      return Future.error(ExceptionService.databaseException(message: e));
    }

    return Future.value(true);
  }

  static Future getCartProduct({int cartId, int productId}) async {
    final db = await SQLiteService.db.database;
    var response;

    try {
      response = await db.query(table,
          where: "cart_id = ? AND product_id = ?",
          whereArgs: [cartId, productId]);
    } catch (e) {
      return Future.error(ExceptionService.databaseException(message: e));
    }

    var responseValue =
        response.isNotEmpty ? CartProduct.fromMap(response.first) : null;
    return Future.value(responseValue);
  }

  static Future createOrUpdateCartProduct(CartProduct cartProduct) async {
    try {
      CartProduct product = await CartProductDBService.getCartProduct(
        cartId: cartProduct.cartId,
        productId: cartProduct.productId,
      );

      if (product == null) {
        await CartProductDBService.createCartProduct(cartProduct);
      } else {
        await CartProductDBService.updateCartProduct(cartProduct);
      }
    } catch (e) {
      return e;
    }

    return Future.value(true);
  }

  static Future getAllCartProducts({int cartId}) async {
    final db = await SQLiteService.db.database;
    var response;

    try {
      response = await db.query(table,
          where: "cart_id = ? AND quantity > 0", whereArgs: [cartId]);
    } catch (e) {
      return Future.error(ExceptionService.databaseException(message: e));
    }

    List<dynamic> productCartList = response.isNotEmpty
        ? response.map((c) => CartProduct.fromMap(c)).toList()
        : [];

    return Future.value(productCartList);
  }

  static Future deleteCartProducts({int cartId}) async {
    final db = await SQLiteService.db.database;

    try {
      var query = 'DELETE FROM $table WHERE cart_id = ?;';
      await db.rawDelete(query, [cartId]);
    } catch (e) {
      return Future.error(
        ExceptionService.databaseException(
          message: e,
        ),
      );
    }
  }
}
