import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';

class LoginController extends GetxController {
  final FirebaseAuthController _authController = Get.find<FirebaseAuthController>();
  var showPassword = true.obs;

  void changeVisibility() => showPassword.toggle();

  Future validateForm(String email, String password) async {
    if (password.length > 8)
      _authController.loginUser(email, password);
    else {
      Get.snackbar("Password is too short", "The password must be at least 8 characters long.");
    }
  }
}
