import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/firebase_auth_controller.dart';
import 'package:notes_app/src/ui/screens/auth/register_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';
import 'package:notes_app/src/ui/widgets/custom_back_button.dart';
import 'package:notes_app/src/ui/widgets/auth/password_field.dart';

class LoginScreen extends StatelessWidget {
  static final String id = '/login';
  final TextEditingController _emailField = TextEditingController();
  final TextEditingController _passwordField = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
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
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      "Welcome Back.",
                      style: TextStyle(fontSize: 30),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "You were missed!",
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
                    prefixIcon: Icon(Icons.email),
                    hintText: "Enter your email",
                  ),
                ),
              ),
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
                        print("Forgot Password");
                      },
                  ),
                ),
              ),
              Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 14)),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                  ),
                  onPressed: () {
                    if (_passwordField.text.length > 8)
                      Get.find<FirebaseAuthController>().loginUser(_emailField.text, _passwordField.text);
                    else {
                      Get.snackbar("Password is too short", "The password must be at least 8 characters long.",
                          snackPosition: SnackPosition.BOTTOM,);
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
    );
  }
}
