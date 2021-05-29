import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';

class RegisterController extends GetxController {
  final FirebaseAuthController _authController = Get.find<FirebaseAuthController>();
  var hidePassword1 = true.obs;
  var hidePassword2 = true.obs;

  void toggleHidePassword1() => hidePassword1.toggle();
  void toggleHidePassword2() => hidePassword2.toggle();

  Future validateForm(String email, String password1, String password2) async {
    if (password1.length > 8 && password2.length > 8) {
      if (password1 == password2)
        _authController.registerUser(email, password1);
      else
        Get.snackbar("Passwords don't match", "Please check the passwords and try again");
    } else {
      Get.snackbar("Password is too short", "The password must be at least 8 characters long.");
    }
  }
}
