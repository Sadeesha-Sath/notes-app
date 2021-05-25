import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:notes_app/src/ui/screens/auth/login_screen.dart';
import 'package:notes_app/src/ui/ui_constants.dart';

class RegisterScreen extends StatelessWidget {
  static final String id = "/register";
  var _email = "";
  var _password = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                  onChanged: (value) {
                    _email = value;
                    //Do something with the user input.
                  },
                  decoration: textFieldDecoration.copyWith(
                    hintText: "Enter your email",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextField(
                  obscureText: true,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                  onChanged: (value) {
                    _password = value;
                    //Do something with the user input.
                  },
                  decoration: textFieldDecoration.copyWith(
                    hintText: "Enter a password",
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                child: TextField(
                  obscureText: true,
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.left,
                  onChanged: (value) {
                    _password = value;
                    //Do something with the user input.
                  },
                  decoration: textFieldDecoration.copyWith(
                    hintText: "Retype the password",
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
                  onPressed: () {},
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
