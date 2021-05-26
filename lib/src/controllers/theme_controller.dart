import 'package:get/get.dart';

class ThemeController extends GetxController {
  RxBool isDarkMode = false.obs;

  void changeTheme(bool value) {
    isDarkMode.value = value;
  }
}
