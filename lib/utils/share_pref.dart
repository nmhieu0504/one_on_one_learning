import 'package:shared_preferences/shared_preferences.dart';

class SharePref {
  static final SharePref _instance = SharePref._internal();

  factory SharePref() {
    return _instance;
  }
  SharePref._internal();

  // method: save data
  void saveString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  // method: get data
  Future<String?> getString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // method: remove data
  void removeString(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(key);
  }
}
