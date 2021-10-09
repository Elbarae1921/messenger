import 'package:shared_preferences/shared_preferences.dart';

class Prefs {
  static Future<SharedPreferences> get prefs async =>
      await SharedPreferences.getInstance();

  static Future<String?> getToken() async {
    return (await prefs).getString('token');
  }

  static Future<void> setToken(String? token) async {
    if (token == null)
      await (await prefs).remove('token');
    else
      await (await prefs).setString('token', token);
  }
}
