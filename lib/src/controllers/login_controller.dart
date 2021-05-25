import 'package:get/get.dart';

class LoginController extends GetxController {
  String email = "";
  String password = "";
  var showPassword = true.obs;

  void changeVisibility() => showPassword.toggle();

  bool validateForm() {
    if (password.length > 8) return true;
    return false;
  }
}
