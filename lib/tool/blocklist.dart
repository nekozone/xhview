import '../core/db.dart';

class BlockList {
  static List<String> username = [];
  static List<int> uid = [];
  static List<int> tid = [];
  static bool isloadend = false;

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
    isloadend = true;
  }

  static Future<bool> adduser(int id, String name) async {
    if (!isloadend) {
      return false;
    }
    if (uid.contains(id)) {
      return false;
    }
    final dbres = await DB.db?.insert('blockuser', {
      'uid': id,
      'name': name,
      "time": DateTime.now().microsecondsSinceEpoch.toString()
    });
    if (dbres != null) {
      username.add(name);
      uid.add(id);
    }
    return true;
  }

  static Future<bool> addpost(int id, String til, String uname) async {
    if (!isloadend) {
      return false;
    }
    if (tid.contains(id)) {
      return false;
    }
    final dbres = await DB.db?.insert('blockpost', {
      'tid': id,
      'title': til,
      'username': uname,
      "time": DateTime.now().microsecondsSinceEpoch.toString()
    });
    if (dbres != null) {
      tid.add(id);
    }
    return true;
  }

  static Future<bool> deluser(int id) async {
    if (!isloadend) {
      return false;
    }
    final dbres =
        await DB.db?.delete('blockuser', where: 'uid = ?', whereArgs: [id]);
    if (dbres != null) {
      username.removeAt(uid.indexOf(id));
      uid.remove(id);
    }
    return true;
  }

  static Future<bool> delpost(int id) async {
    if (!isloadend) {
      return false;
    }
    final dbres =
        await DB.db?.delete('blockpost', where: 'tid = ?', whereArgs: [id]);
    if (dbres != null) {
      tid.remove(id);
    }
    return true;
  }
}
