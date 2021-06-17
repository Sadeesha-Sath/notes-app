import 'package:shared_preferences/shared_preferences.dart';

class LocalPreferences {
  static late final SharedPreferences _preferences;

  // static SharedPreferences get preferences => _preferences;

  static onInit() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static bool get biometrics => _preferences.getBool("Biomet") ?? false;

  static bool? get isDarkMode => _preferences.getBool("isDarkMode");

  static set isDarkMode(bool? value) => _preferences.setBool("isDarkMode", value ?? false);
  static set biometrics(bool value) => _preferences.setBool("Biomet", value);
}
