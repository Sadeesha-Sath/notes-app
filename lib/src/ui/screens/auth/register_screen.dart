import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/ui/screens/app/home_screen.dart';
import 'package:notes_app/src/ui/screens/auth/login_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';
import 'package:notes_app/src/ui/widgets/password_field.dart';

class RegisterScreen extends StatelessWidget {
  static final String id = "/register";
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _password1Field = TextEditingController();
  final TextEditingController _password2Field = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.size.width / 50, vertical: Get.size.height / 45),
          child: Column(
            children: [
              Container(alignment: Alignment.topLeft, child: CustomBackButton()),
              Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Let's sign you up.",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Welcome Onboard!",
                      style: TextStyle(fontSize: 30),
                    ),
                  ],
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextField(
                  style: TextStyle(fontSize: 16),
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.left,
                  controller: _emailField,
                  decoration: textFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Enter your email",
                  ),
                ),
              ),
              PasswordTextField(controller: _password1Field, key: ValueKey(1)),
              PasswordTextField(controller: _password2Field, hintText: "Retype Password", key: ValueKey(2),),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  onPressed: () {
                    if (_password1Field.text.length > 8 && _password2Field.text.length > 8) {
                      if (_password1Field.text == _password2Field.text)
                        Get.find<FirebaseAuthController>().registerUser(_emailField.text, _password1Field.text);
                      else
                        Get.snackbar("Passwords don't match", "Please check the passwords and try again");
                    } else {
                      Get.snackbar("Password is too short", "The password must be at least 8 characters long.");
                    }
                  },
                  child: Center(
                    child: Text(
                      "Register",
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              ),
              Spacer(),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: "Already a User?  "),
                    TextSpan(
                      text: " Sign In ",
                      style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          Get.offNamed(LoginScreen.id);
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
    );
  }
}
