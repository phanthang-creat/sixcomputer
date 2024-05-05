import 'package:shared_preferences/shared_preferences.dart';

class AppPreference {
  static final AppPreference _singleton = AppPreference._internal();

  factory AppPreference() {
    return _singleton;
  }

  AppPreference._internal();

  init() async {
    _preference = await SharedPreferences.getInstance();
  }

  SharedPreferences? _preference;

  String? getData(String key) {
    return _preference?.getString(key);
  }

  int? getIntData(String key) {
    return _preference?.getInt(key);
  }

  bool? getBoolData(String key) {
    return _preference?.getBool(key);
  }

  List<String>? getStringList(String key) {
    return _preference?.getStringList(key);
  }

  Future<bool?> setData(String key, Object? data) async {
    if (data is int) {
      return await _preference?.setInt(key, data);
    }
    if (data is String) {
      return await _preference?.setString(key, data);
    }
    if (data is bool) {
      return await _preference?.setBool(key, data);
    }
    if (data is List<String>) {
      return await _preference?.setStringList(key, data);
    }
    return false;
  }

  void removeData(String key) {
    _preference?.remove(key);
  }
}

AppPreference appPreference = AppPreference();
