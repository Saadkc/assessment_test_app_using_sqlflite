import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../services/database.dart';

class DatabaseService {
  Database? _database;

  Future<Database> get database async {
    if(_database != null){
      return _database!;
    }
    _database = await _intialize();
    return _database!;
  }

  Future<String> get path async {
    const name = 'todo.db';
    final path = await getDatabasesPath();
    return join(path,name);
  }

  Future<Database> _intialize() async {
    final path = await this.path;
    return await openDatabase(
      path,
      version: 1,
      onCreate: create,
      singleInstance: true
    );
  }

  Future<void> create(Database database, int version) async => await SqlDatabaseService().createTable(database);
}