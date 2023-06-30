import '../core/db.dart';

class BlockList {
  static List<String> username = [];
  static List<int> uid = [];
  static List<int> tid = [];

  static Future<void> loadlist() async {
    final dbres = await DB.db?.query('blockuser', columns: ['uid', 'name']);
    if (dbres != null) {
      for (final item in dbres) {
        username.add(item['name'] as String);
        uid.add(item['uid'] as int);
      }
    }
    final dbres2 = await DB.db?.query('blockpost', columns: ['tid']);
    if (dbres2 != null) {
      for (final item in dbres2) {
        tid.add(item['tid'] as int);
      }
    }
  }

  static Future<void> adduser(int id, String name) async {
    final dbres = await DB.db?.insert('blockuser', {
      'uid': id,
      'name': name,
      "time": DateTime.now().microsecondsSinceEpoch.toString()
    });
    if (dbres != null) {
      username.add(name);
      uid.add(id);
    }
  }

  static Future<void> addpost(int id) async {
    final dbres = await DB.db?.insert('blockpost',
        {'tid': id, "time": DateTime.now().microsecondsSinceEpoch.toString()});
    if (dbres != null) {
      tid.add(id);
    }
  }

  static Future<void> deluser(int id) async {
    final dbres =
        await DB.db?.delete('blockuser', where: 'uid = ?', whereArgs: [id]);
    if (dbres != null) {
      username.removeAt(uid.indexOf(id));
      uid.remove(id);
    }
  }

  static Future<void> delpost(int id) async {
    final dbres =
        await DB.db?.delete('blockpost', where: 'tid = ?', whereArgs: [id]);
    if (dbres != null) {
      tid.remove(id);
    }
  }
}
