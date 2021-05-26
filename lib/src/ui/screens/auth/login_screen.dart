import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/controllers/login_controller.dart';
import 'package:notes_app/src/ui/screens/app/home_screen.dart';
import 'package:notes_app/src/ui/screens/auth/register_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class LoginScreen extends StatelessWidget {
  static final String id = '/login';
  final LoginController _loginController = LoginController();

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
                child: IconButton(
                  splashRadius: 27,
                  icon: Icon(Icons.arrow_back_ios_new_sharp),
                  onPressed: () {
                    Get.back();
                  },
                ),
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
                  onChanged: (value) {
                    _loginController.email = value;
                    //Do something with the user input.
                  },
                  decoration: textFieldDecoration.copyWith(
                    prefixIcon: Icon(Icons.person),
                    hintText: "Enter your email / username",
                  ),
                ),
              ),
              Obx(
                () => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: TextField(
                    obscureText: _loginController.showPassword.value,
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.left,
                    onChanged: (value) {
                      _loginController.password = value;
                      //Do something with the user input.
                    },
                    decoration: textFieldDecoration.copyWith(
                      prefixIcon: Icon(Icons.password),
                      suffixIcon: IconButton(
                        splashRadius: 20,
                        onPressed: () {
                          print("Changing Visibility");
                          _loginController.changeVisibility();
                        },
                        icon: Icon(_loginController.showPassword.value
                            ? Icons.visibility_rounded
                            : Icons.visibility_off_rounded),
                      ),
                      hintText: "Enter your password",
                    ),
                  ),
                ),
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
                    Get.offAllNamed(HomeScreen.id);
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
