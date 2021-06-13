import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/ui/screens/auth/forgot_password_screen.dart';
import 'package:notes_app/src/ui/screens/auth/register_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/auth/email_text_field.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';
import 'package:notes_app/src/ui/widgets/auth/password_field.dart';

class LoginScreen extends StatelessWidget {
  static final String id = '/login';
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();
  final showSpinner = false.obs;
  final Rx<String?> error = Rx(null);

  @override
  Widget build(BuildContext context) {
    var kSizedBox20;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            height: 13 * Get.height / 14,
            padding: EdgeInsets.symmetric(horizontal: Get.size.width / 50, vertical: Get.size.height / 45),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  child: CustomBackButton(),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Let's sign you in.",
                        style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                      ),
                      kSizedBox20,
                      Text(
                        "Welcome Back.",
                        style: TextStyle(fontSize: 30),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "You were missed!",
                        style: TextStyle(fontSize: 30),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                EmailTextField(controller: _emailField),
                PasswordTextField(
                  controller: _passwordField,
                  hintText: "Enter Your Password",
                  key: ValueKey(3),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Text.rich(
                    TextSpan(
                      text: "Forgot Password?",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 15.5,
                        fontWeight: FontWeight.w600,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.toNamed(ForgotPasswordScreen.id);
                        },
                    ),
                  ),
                ),
                kSizedBox10,
                Obx(() => Visibility(
                      visible: error.value != null,
                      child: Text(
                        error.value.toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16.5, color: Colors.redAccent),
                      ),
                    )),
                Spacer(),
                Obx(() => Visibility(
                    visible: showSpinner.value,
                    child: Container(
                        margin: EdgeInsets.symmetric(vertical: 10), child: CircularProgressIndicator.adaptive()))),
                kSizedBox10,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: ElevatedButton(
                    style: ButtonStyle(
                      padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14)),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                    ),
                    onPressed: () async {
                      if (_passwordField.text.length > 8) {
                        showSpinner(true);
                        await Get.find<FirebaseAuthController>()
                            .loginUser(_emailField.text, _passwordField.text, error);
                        showSpinner(false);
                      } else {
                        error.value = "Password is too short. The password must be at least 8 characters long.";
                      }
                    },
                    child: Center(
                      child: Text(
                        "Sign In",
                        style: TextStyle(fontSize: 17),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: "New to Our Family?  "),
                      TextSpan(
                        text: " Register ",
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Get.offNamed(RegisterScreen.id);
                          },
                      ),
                    ],
                  ),
                  style: TextStyle(fontSize: 15.5),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
