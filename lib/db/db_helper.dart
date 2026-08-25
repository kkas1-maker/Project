import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  Future<Database> initDB() async {
    String path = await getDatabasesPath();
    String dbName = 'financeiro.db';

    String dbPath = join(path, dbName);

    Database db = await openDatabase(dbPath, version: 1, onCreate: onCreateDB);

    return db;
  }

  FutureOr<void> onCreateDB(Database db, int version) async {
    String sql = ''' CREATE TABLE transacoes (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            titulo TEXT,
            valor REAL,
            isEntrada INTEGER,
            categoria TEXT,
            data TEXT
        );''';

    await db.execute(sql);
  }
}
