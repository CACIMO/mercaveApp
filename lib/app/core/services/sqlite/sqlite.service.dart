import 'dart:async';
import 'dart:io';

import 'package:mercave/app/core/config.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/_local_storage/local_storage.db.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/cart/cart.model.dart';
import 'package:mercave/app/core/services/sqlite/tables/cart/cart.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/cart_product/cart_product.service.dart';
import 'package:mercave/app/core/services/sqlite/tables/user/user.service.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SQLiteService {
  static Database _database;

  SQLiteService._();
  static final SQLiteService db = SQLiteService._();

  Future<Database> get database async {
    if (_database != null) return _database;

    _database = await initializeDatabase();
    await initializeDatabaseInfo();
    return _database;
  }

  Future<Database> initializeDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    // String path = documentsDirectory.path + ConfigService.DATABASE_NAME;
    String path =
        p.join(documentsDirectory.toString(), ConfigService.DATABASE_NAME);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(LocalStorageDBService.scheme);
        await db.execute(CartDBService.scheme);
        await db.execute(CartProductDBService.scheme);
        await db.execute(UserDBService.scheme);
      },
    );
  }

  Future initializeDatabaseInfo() async {
    try {
      await CartDBService.createCart(Cart(id: 1, description: ''));
    } catch (e) {}
  }
}
