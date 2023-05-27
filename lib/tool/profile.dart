import 'package:shared_preferences/shared_preferences.dart';

class UserProfiles {
  static late SharedPreferences prefs;
  static String darkmode = '';
  static init() async {
    prefs = await SharedPreferences.getInstance();
    String? dark = prefs.getString('darkmode');
    if (dark == null) {
      dark = 'system';
      prefs.setString('darkmode', dark);
    }
    darkmode = dark;
  }

  static setDarkmode(String mode) async {
    prefs.setString('darkmode', mode);
    darkmode = mode;
  }
}
