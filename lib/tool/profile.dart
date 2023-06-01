import 'package:shared_preferences/shared_preferences.dart';

class UserProfiles {
  static late SharedPreferences prefs;
  static String darkmode = '';
  static bool isLogin = false;
  static init() async {
    prefs = await SharedPreferences.getInstance();
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
  }

  static setDarkmode(String mode) async {
    prefs.setString('darkmode', mode);
    darkmode = mode;
  }

  static setLogin(bool login) async {
    prefs.setString('login', login.toString());
    isLogin = login;
  }
}
