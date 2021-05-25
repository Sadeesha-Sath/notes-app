import 'package:get/get.dart';

class RegisterController extends GetxController {
  String email = "";
  String password1 = "";
  String password2 = "";
  var hidePassword1 = false.obs;
  var hidePassword2 = false.obs;

  void toggleHidePassword1() => hidePassword1.toggle();
  void toggleHidePassword2() => hidePassword2.toggle();

  bool validateForm() {
    if (password1.length > 8 && password2.length > 8) {
      if (password1 == password2) return true;
    }
    return false;
  }
}
