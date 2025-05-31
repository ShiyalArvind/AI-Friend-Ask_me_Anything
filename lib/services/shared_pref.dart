
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constant_file.dart';

class SharedPreference {
  static final SharedPreference _instance = SharedPreference._internal();

  factory SharedPreference() => _instance;

  SharedPreference._internal();

  SharedPreferences? _prefs;

  static String userId = ConstantsFile.sharedPrefUserId;
  static String stayLoggedIn = ConstantsFile.sharedPrefStayLoggedIn;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> setStringPref(String key, String value) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setString(key, value);
  }

  Future<String> getStringPref(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getString(key) ?? "";
  }

  Future<void> setBooleanPref(String key, bool value) async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs!.setBool(key, value);
  }

  Future<bool> getBooleanPref(String key) async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!.getBool(key) ?? false;
  }

  Future<void> clearSharedPref({String? key}) async {
    _prefs ??= await SharedPreferences.getInstance();
    if (key != null) {
      await _prefs!.remove(key);
    } else {
      await _prefs!.clear();
    }
  }
}
