
import 'package:sqflite/sqflite.dart';

import '../config/database_config.dart';
import '../model/item_model.dart';

class SqlDatabaseService {
  final tableName = 'items';

  Future<void> createTable(Database database) async {
    await database.execute('''
      CREATE TABLE $tableName(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        itemName TEXT NOT NULL,
        itemPrice INTEGER NOT NULL,
        created_at INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertItem({required String itemName, required int itemPrice }) async {
    final database = await DatabaseService().database;
    return await database.rawInsert('''
      INSERT INTO $tableName(itemName, itemPrice, created_at)
      VALUES(?, ?, ?)
    ''', [itemName,itemPrice, DateTime.now().millisecondsSinceEpoch]);
  }

  Future<List<Item>> fetchItem() async {
    final database = await DatabaseService().database;
    final data = await database.rawQuery('''
      SELECT * FROM $tableName
    ''');
    return data
        .map((e) => Item.fromJson(e))
        .toList();
  }

  Future<int> updateItem({required int id, String? itemName, int? itemPrice}) async {
    final database = await DatabaseService().database;
    return await database.update(tableName, {
      if(itemName != null) 'itemName': itemName,
      if(itemPrice != null) 'itemPrice': itemPrice,
    },
    where: 'id = ?',
    conflictAlgorithm: ConflictAlgorithm.rollback,
    whereArgs: [id]
    );
  }

  Future<void> deleteItem(int id) async {
    final database = await DatabaseService().database;
    await database.rawDelete('''
      DELETE FROM $tableName WHERE id = ?
    ''', [id]);
  }
}
