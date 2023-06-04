import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class UserProfiles {
  static late SharedPreferences prefs;
  static String darkmode = '';
  static bool isLogin = false;
  static String username = '';
  static String password = '';
  static late Directory appDocDir;
  static init() async {
    prefs = await SharedPreferences.getInstance();
    appDocDir = await getApplicationDocumentsDirectory();
    String? dark = prefs.getString('darkmode');
    if (dark == null) {
      dark = 'system';
      prefs.setString('darkmode', dark);
    }
    String? login = prefs.getString('login');
    if (login == null) {
      login = 'false';
      prefs.setString('login', login);
    }
    isLogin = login == 'true';
    darkmode = dark;

    username = prefs.getString('username') ?? '';
    password = prefs.getString('password') ?? '';
  }

  static setDarkmode(String mode) async {
    prefs.setString('darkmode', mode);
    darkmode = mode;
  }

  static setLogin(bool login) async {
    prefs.setString('login', login.toString());
    isLogin = login;
  }

  static setUsername(String name) async {
    prefs.setString('username', name);
    username = name;
  }

  static setPassword(String pass) async {
    prefs.setString('password', pass);
    password = pass;
  }
}
