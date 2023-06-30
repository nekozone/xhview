import 'package:sqflite/sqflite.dart';
import '../tool/blocklist.dart';

class DB {
  static Database? db;
  static const String dbname = 'data.db';
  static String path = '';

  static Future<void> init() async {
    if (db != null) {
      return;
    }

    try {
      path = await getDatabasesPath() + dbname;
      db = await openDatabase(path, version: 1, onCreate: _onCreate);
    } catch (ex) {
      // print(ex);
    }
    BlockList.loadlist();
  }

  static void _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE blockuser(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        uid INTEGER,
        name TEXT,
        time TEXT
      )
    ''');
    await db.execute('''
      CREATE TABLE blockpost(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        tid INTEGER,
        title TEXT,
        username TEXT,
        time TEXT
      )
    ''');
  }
}
